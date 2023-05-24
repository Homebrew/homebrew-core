class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.18/psysh-v0.11.18.tar.gz"
  sha256 "ae8a27241a4c5ce02c6bf2323e7de44755521c7fe450916e514ea6c9523b63e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44a772918a4cc4698544ebd2e7e6f6c7a51d0cd75f56c69cb315903c4dbb09a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44a772918a4cc4698544ebd2e7e6f6c7a51d0cd75f56c69cb315903c4dbb09a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44a772918a4cc4698544ebd2e7e6f6c7a51d0cd75f56c69cb315903c4dbb09a2"
    sha256 cellar: :any_skip_relocation, ventura:        "3cf41109eeb7c16020e4d385c05bd8cac088d98738bce0a042f16ab25ad18e30"
    sha256 cellar: :any_skip_relocation, monterey:       "3cf41109eeb7c16020e4d385c05bd8cac088d98738bce0a042f16ab25ad18e30"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cf41109eeb7c16020e4d385c05bd8cac088d98738bce0a042f16ab25ad18e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44a772918a4cc4698544ebd2e7e6f6c7a51d0cd75f56c69cb315903c4dbb09a2"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~EOS
      <?php echo 'hello brew';
    EOS

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end
