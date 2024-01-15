class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.48.3",
      revision: "b643a1b4c6ae89aba13cc594835a3f6ba9b7760d"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b1fc533341fead1bc05024397a03f1b3dba1c89ab79963ec2ba5f88b70dc66a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7cab7699f875f0083df9c1ac1e0028f9c4a4dcbf9e3318d48fb9cf189dff14c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "621732511d77497d0a56cc0708e5e41a1602e73a0cdb61f323b22ae05fbc3ebf"
    sha256 cellar: :any_skip_relocation, ventura:        "c70469ddf36357c2429611618c6d31781d76041b61bcc5481a52ebad16a95c0e"
    sha256 cellar: :any_skip_relocation, monterey:       "699e64f782721e940efec695c158273b32233c1622556a03cab4176a8152f5f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fda7ad70018cee40e43d710dfa824b975a083075c2843beb82c257945219df58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2766226ca4dfee070ff506183bb421cabba8a1c1e1accc9d12b581a5a782fd70"
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
