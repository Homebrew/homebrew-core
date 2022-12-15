class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.36.0",
      revision: "3a0f7f089f529e0ce2f29785735b05b30e730d2b"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7e525b03c092a2318cc7cc54fc9f2d523389600c56ca8835d472c4eb5362161"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5238a2f5b3e02afe42ea59245a1d6a03803cd6d41f910493d28129d7f30b1d7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c744d8f3927347f229b97950128b78a4aafaa83bbf736158f1ec2ae1de78ec9"
    sha256 cellar: :any_skip_relocation, ventura:        "39aa80a76bed84d27fef9dd1d697d9486e78b1824efcb05ceb30e350cb7b5870"
    sha256 cellar: :any_skip_relocation, monterey:       "10e6c10a94a3d017a106b045499ec5e9bd4b8cecde02b781a1fd21cccf0145c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b5729317fb943482774f37d9c3361e4a61ab16e216cdc3840cf27f6d577e91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04cd8b0ed18455fbf8b1dba96d0fd2495a875e07a5709e4e884db563ff26ef42"
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
    run [bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end
