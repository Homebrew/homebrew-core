class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.43.1",
      revision: "50a7f5cb24d27892af6d5ccde590fd10fa69f3e1"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d11ee95c1abffbb532733056c04e12cf86db3af915c712e5e59ab3ffb3422a7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c446c7d1ff6bdc68e50b16bf0e11d40f56f39371b494e7c76d0ff0861b713e17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d3ba128f7dd53ce3cf6edf79ada7152d2ea829d5ab912b611cd87d9fdd4a62c"
    sha256 cellar: :any_skip_relocation, ventura:        "3ff33052b12212250f69103acdf835d16e312070670b3bfe539b3adf345483c6"
    sha256 cellar: :any_skip_relocation, monterey:       "f06a83473d4759334cadcfe30bc5cc68cf3be1280faf9465cb6e9407609cba97"
    sha256 cellar: :any_skip_relocation, big_sur:        "87e556a51324cd0a135fe2ec77df07a05c3980a55d8f8816f5c379daa06b39d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14c6aa5d9fb81fcad88e34005cc93435c3a475307b7ce394c676472506856e4c"
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
