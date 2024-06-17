class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.52.3",
      revision: "83eb325f68a1714588b8f3deeba44e79da2e8e2f"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a2b66cbcee75f87c37ec9f25f3102b2515d03e8fe413b2dc29007829ac292b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8aa581d276a74cd8aa141cec5e4035717b1c22fdd0203ee722411bb7ee78772f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8fb5af14d42aa6d2df1d470887e3c2732b983dc8cd23d377611be1aa7c6be16"
    sha256 cellar: :any_skip_relocation, sonoma:         "7361c0829c705fb2a49c8e7a05908977b7a5d028564395feda8d9a35a5b6cf8e"
    sha256 cellar: :any_skip_relocation, ventura:        "fec8431a1e3f7de6773d7132afca8a0c5c4a0c2d7825aee1c5252f20518f1a6f"
    sha256 cellar: :any_skip_relocation, monterey:       "657603fedf9c6ce56fd149a572017bf7f5c8dfdbe8dcc899f0e11330d1dfe912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a461d2d48c764ab4af3d43c1cab61192af2cb7f11cc2beb7d70c420b21f04ebd"
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
