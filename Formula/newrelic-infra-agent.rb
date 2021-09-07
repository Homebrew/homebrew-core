class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent/archive/refs/tags/1.20.2.tar.gz"
  sha256 "83f521ed6ed903d9fdbeed8eb59b6b488ce5492fe305d38a7096d4c2f017138d"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "4106b38ed2037ceebb6e984b9e53b9e4c03353bd306a8db75c2122da6ef8cb41"
    sha256 cellar: :any_skip_relocation, catalina:     "0db6721dc524dbbdfa5a7e27d51dca6691466e7b3be621f46909d55cf1c81fc1"
    sha256 cellar: :any_skip_relocation, mojave:       "0ebf0c24dcf57bf8c872354d924b8076b83b4e771a351527629734d1c896f402"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "80a1f2d22913a89ec427d20a8e03579b6de3f74e23ecf7db99546d513eec35f6"
  end

  depends_on "go" => :build
  # https://github.com/newrelic/infrastructure-agent/issues/695
  depends_on arch: :x86_64

  def install
    goarch = Hardware::CPU.arm? ? "arm64" : "amd64"
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = if OS.mac?
      ENV["CGO_ENABLED"] = "1"
      "darwin"
    else
      ENV["CGO_ENABLED"] = "0"
      "linux"
    end
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
