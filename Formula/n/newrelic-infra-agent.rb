class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.52.1",
      revision: "2f3cfea8406815c1d81d0bea05a83d80cfb279f4"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b98497fe16720e591e0b47461d8289c017dd3cadce511b95dc93a7660bcef10b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2b0318af4ef01a5ba2b23684a72670fc26be3c90a53765110a226d9ff14f325"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa97702475de18656deaa84c1b423d2979e524a695f3417c73ea67be7bdac2b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b83a62c4c77d83b7b0be017d31f1fb1c82af4114c2831d7de72e5511e7e30df"
    sha256 cellar: :any_skip_relocation, ventura:        "1de835c6678001d19034ea1be32e81c1d018cd77a7e64c985a40b647f9967496"
    sha256 cellar: :any_skip_relocation, monterey:       "e6bc4df8752b014524dc509e2b08a803d1e564f1b93421f3498c13f6b691155e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20a46a4b466c553dba627e2f6313c74a20721687ec2bc685bc9417f4d08a33d3"
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
