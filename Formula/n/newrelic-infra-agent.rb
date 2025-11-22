class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.71.1",
      revision: "d252cea32d3671d8677ad2a13908183a973549b4"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b2144f51a927227b96dcbaf3f865217e3664904155458c60dfc9173219a1aae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fcb05c1f1a90b94d625b570374a5e1a3c8defeea177ede38882d2195b88c0f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f27892f439e52d33e15f7f598982f32c3516f7dddfdbfb6e994153662ce528ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9e7a48730d9e270c8f00a5c6457f7a8794d4e69dc0f9f008c523ba762eeed1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b28ddff595bd7e64b1a744238c9054033ea6c40f32ef636b811776684524810b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67d9f412059630cb4327aa15f6febb712e28ad2eb05c6777028fe48c721997f8"
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
