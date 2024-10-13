class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.57.2",
      revision: "edc8ef7b36ee41f1e3488cfcd56c2a2d9e08fcef"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dbb71367e7e6b71eb174e0e453bef64a58e7d2e0e80578144560f363cfb4cea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9dc70943438a67e650cd739af9ebe7b2ee405db697ea011c8e1278f38c28324"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8fba9613f3fa2e7151b1f829a7f26da75d110f3e05992a00707bf439ba254a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d8f5ff329746a235dac2d1ff7a05bc1ddf75b55ea292570e062be5f96b360b2"
    sha256 cellar: :any_skip_relocation, ventura:       "5ffdac30b44c5cff35ab37ef3ad2316fc37a8449f07f9b104798f57c64ea1068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2950132c902bdc95392b832a1ee8c29dec658622246c47e34f90e2e6dac0c1fd"
  end

  depends_on "go" => :build

  def install
    goarch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = os
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ENV["GOARCH"] = goarch

    system "make", "dist-for-os"
    bin.install "dist/#{os}-newrelic-infra_#{os}_#{goarch}/newrelic-infra"
    bin.install "dist/#{os}-newrelic-infra-ctl_#{os}_#{goarch}/newrelic-infra-ctl"
    bin.install "dist/#{os}-newrelic-infra-service_#{os}_#{goarch}/newrelic-infra-service"
    (var/"db/newrelic-infra").install "assets/licence/LICENSE.macos.txt" if OS.mac?
  end

  def post_install
    (etc/"newrelic-infra").mkpath
    (var/"log/newrelic-infra").mkpath
  end

  service do
    run [opt_bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end
