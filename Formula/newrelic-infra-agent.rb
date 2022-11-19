class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.33.2",
      revision: "90f8742f0e26b25d48bb02546f11d28311e597d2"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adc596149a404c706e2e6e829b11731c9c1457645c5cf95dcbae9e7a6cd53657"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "327d4d460c0fb763261dd04d79434bf3f92836ad274b03b215defa87d013fb17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f307b1926a07b75663ed25f075804c81ab62e13f30749818c81959b92f1d6514"
    sha256 cellar: :any_skip_relocation, ventura:        "494a593b9f7dba278d4bf8602deebd520be914582b402f774e2e4f0c2ef288fc"
    sha256 cellar: :any_skip_relocation, monterey:       "037c36cac1fe92f5a585631f2656da56a7a23e8ae981c56b19e4d1016a750c18"
    sha256 cellar: :any_skip_relocation, big_sur:        "75a5267a68857a39dfe477f154a4be104aa4f93483565802cdbd7ff54726376a"
    sha256 cellar: :any_skip_relocation, catalina:       "146d80f3fbd4daca90ca2e91acd73fcaaa774506c628abee773b330bdb11411c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce20ca8a798a166772be21d215ac88d418d419927ef3282a18d85c0ce5314cc3"
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
