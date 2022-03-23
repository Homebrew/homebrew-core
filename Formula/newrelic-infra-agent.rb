class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.24.0",
      revision: "6b639750a46d781f32444b0a77bc4e965b85a569"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "781856b152edfb19df8334df6dbce4b3336925edd47c0f06b45e6da9513f9545"
    sha256 cellar: :any_skip_relocation, big_sur:      "a81d7fcbc212cffbc0eb9da610a15e2e05488458118f46cb8593337707ba3d51"
    sha256 cellar: :any_skip_relocation, catalina:     "ecad63ec09777215aecac15f1ee6e2c21f2b72c1aa5b4c019fd321bcf8a0f4aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e5a6bb4cfe547f99e6b0aec27cd44c5bbf8b974b3c82027c40f6a1ce3a19fb92"
  end

  # https://github.com/newrelic/infrastructure-agent/issues/723
  depends_on "go@1.16" => :build
  # https://github.com/newrelic/infrastructure-agent/issues/695
  depends_on arch: :x86_64

  def install
    goarch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = os
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

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
