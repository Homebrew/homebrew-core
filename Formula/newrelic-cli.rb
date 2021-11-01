class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.26.tar.gz"
  sha256 "d49c741162a8fd1030e5d2c976bfe400da1665e37231ac3957ec12c88faef550"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f089cbaf154dc7166550701c442658ebcb8ae4ce1d834e69587ef3bd546224"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29fe8dbd11bdb0fe6c74106fe0d75b2f6c8f5809a817d01c1a44821386509c3b"
    sha256 cellar: :any_skip_relocation, monterey:       "11fe11ddeaf46e934179312d67aaa486b0f4c5fe65931bd19eb6c882b1e1b4d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a3eebeb03c2b7eea31ada5008186f9057ec8ce279550ab9feeccc472f566c43"
    sha256 cellar: :any_skip_relocation, catalina:       "28bf028d6401b54f6773e18978515cb48155227507596c805988a4696313ab8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd88ebd4d29b76bcda523ca9dafaa34dda6c96c2285c8d6300be8570d69b29f6"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
