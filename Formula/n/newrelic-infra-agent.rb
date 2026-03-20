class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.72.8",
      revision: "b328a9ca0d13d3b2fb96be702794d4a2e4baa5e3"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e2cd9468c8f5c3af494bb2caadbd5b6780ea1376234871fd9e4df9282ce8211"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa7b88f4e66c63b11ebdccb4aa6804e739dd0d81d662efd03d776ec623bb5d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29a6a6c726c7cfabd9c268a519b6a0135ffc85566db1ac15a556222bcf477cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2668c321b1045ec157be064b99a8f67cc0017aafb49a0eedfa2fce111b5eebb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0e4e5d6dc081efd864c838d09daa44bc3314370c8d3e374b09849328e3646c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b1b355e4fddce393889663f3fb5e1506631f5a0a79f7f72e3da56243dcc2f8"
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
