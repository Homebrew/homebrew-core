class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.37.0",
      revision: "e6524dec08c8eab730aa99e3930baf00cbed1954"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf929643c08a803a8cf4b914ea1c5b800fbd437ad4ceb2d875f4888652bb56d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79d724ce8cb2f02066d508c7ffeb01e847ff1c192298e4fb4b0175a5230571ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9767484d71eae4ededa93c32ea1a606f31f35af02b3fad18d685a021b412a8f5"
    sha256 cellar: :any_skip_relocation, ventura:        "afb4e0def6d5de3cd270ce2864f547d968e2eb17ffd5a0d7c3dd81bc421b10b0"
    sha256 cellar: :any_skip_relocation, monterey:       "7a3089f17a5af36eaa128a237b8c07b2f467ce2ac5451483c36f5852641fb243"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0571fb87fb53662345b7fcf1f9bed344eec9115482d18701445860cecde34dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d0998c82b43ee5a0a283d0977993d5687cca922e48b5536f98c3073a38194e4"
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
