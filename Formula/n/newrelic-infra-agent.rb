class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.65.3",
      revision: "a53f431bff4cfa8c4547bc65b8d5cd98b667555b"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90a2f2c32c566763892605291257795e8ab9816207caf47248c50f1317ec406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07269a73c0545545c69feadb12d562444718741e02b506bd8ca75aa764ba9bb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91e461419eb2294db0ce9bfb706024769304ed89c44172daa511a88687c652ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ce9e08631ae7019ff58a49586f06b287a8497d8dc335dfba6b51d180dfcb34d"
    sha256 cellar: :any_skip_relocation, ventura:       "214b6b73a19ce84905985dd0c7c8738e3992818f1cffd66b856dd9ebc6e19887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cd950dbc9777c95113891c593848347c6a9b20ab1e3380323676177e7bf2807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c452906a2602bd6e7131ac336081afa8807879ebb6ae00b799a19e0bc19e3e18"
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
