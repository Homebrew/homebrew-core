class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.47.2",
      revision: "9b48d5394edc7b657c6c29817e0d095cc2547ec6"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f0622b7a0a96751658b51e9ec361ad5dd5e2106b1b4d5133a44c8404946be75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ba2f8b5caed0286fe662c3086fcb12145b4a9a11e0efc936fca9129f9147513"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87cba18a0cc7104ef5bfe2f5e216f60b33cf8136d166b9cbad64b376c030266f"
    sha256 cellar: :any_skip_relocation, sonoma:         "453fdf3c4a25d7245969a1a5d332074bb15f6d70231eec0e17bb4848fc438e39"
    sha256 cellar: :any_skip_relocation, ventura:        "dd726221894f975290904fc704f1b0105caba2393be95450ade2bf1eb93c25e4"
    sha256 cellar: :any_skip_relocation, monterey:       "fa594d5f337d665892bce2cbdfd814f222c05a34d7f21e02496a680fc3fed1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26099f1fd90b89a09fe31f9fa5313ee182176c20d1e6f5c489a02a6acca91787"
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
