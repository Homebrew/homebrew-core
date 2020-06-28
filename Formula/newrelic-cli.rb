class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.9.0.tar.gz"
  sha256 "4c64549baaefae241ae8ff152e600e6092f33a1e1525a39a323cc69e459c66cd"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "83fc073b4f87223a313080d4339a8d11be3d019810417702d4660f4c55e6ab39" => :catalina
    sha256 "f4c9d2779d09f3f08b4dae1864c257a5edeb42b4c07c5b9ba2eb23cc0223eab8" => :mojave
    sha256 "ded44c6b5612160f33fa7fe468210a09f365ca8a7f1b9248290fa47661ca496c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
