class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.76.1",
      revision: "a5b0074553476de41f9f71127908d0d8e3c6ab9b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "870e4c5356a001bc83d1ee6201765c9cb96753783f54dbd65791a9bf77b9d2c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff40e4f0011272dba162ece168849877b63853a91cc7af3c35c466c0f712ab61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7cb2848a5649ba3a1a1b9e034b301d8d732b5a2ee596351c6e34b2dd1e9c883"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d8d87ad5d537f89f9028e03f631b2038df12b69cece02decb7a30b02a7d22ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73f10cde8da281f916337dfe9d14258e861b1d754b9e3e6307817f6d840c7fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dd0302f65f6b1958ffb8de808946704236471843908fd952bf751f01564ae92"
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
