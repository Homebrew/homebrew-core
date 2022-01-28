class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.17.tar.gz"
  sha256 "fa8745723385a3db543c04bddd546a62c382778a9d1364171ee407c4434c87d2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7e2a2dc8f177cecb55d3fbc4279d7720448279a1c723980c0f97d12c6ab345b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bdec972020ff35166c617771b4e3ffda78e9c6fbff929f59616658e76d78c98"
    sha256 cellar: :any_skip_relocation, monterey:       "760232dde47bdb1cb181e566399fd11308ae4937ac04c644bb5a4f1d0825c245"
    sha256 cellar: :any_skip_relocation, big_sur:        "77c37f5b906cd70de6b3f4f5d84a987faf3828667b99dd0e61ce436e56912704"
    sha256 cellar: :any_skip_relocation, catalina:       "b5a69f54c32be4deb8964d18942bee9aa8cba8ffd236d41a4191329d6b74e55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d2a099117079acff744811b90a4d2e01d2b1338516cac17ad9435ffff11c5d"
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
