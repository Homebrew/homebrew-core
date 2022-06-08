class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.2.tar.gz"
  sha256 "4b779e746cebf1d4ee50bd185e899a49b1914041ce09340a5036135fbc20f71f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d50abfbd58fff0b3613a3c8357b8d57eff044ce8a6efa76589e7ea9249a4e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8547e0c055154fb9dc79881c2e44998465373b312807d5eb3687775996dbe17c"
    sha256 cellar: :any_skip_relocation, monterey:       "ff2bca841801213565b131158760be65c498e12d7d3f5f59123743e12d7de5d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9f8faa31b5266b7c610e13a0136eafee62462db618ec57606123e7a7759b41f"
    sha256 cellar: :any_skip_relocation, catalina:       "fbcf470d8e5ea475bf61f92071686f9dc6a154c1227af42cafe51ba5bedb25b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ece42670211eb9f674c01ba3dd0707cb7b89a95810589b70c5a7882e14fa5e"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "fish")
    (fish_completion/"newrelic.fish").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
