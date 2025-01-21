class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.7/psysh-v0.12.7.tar.gz"
  sha256 "aad77c3b69e39289b8a3309aedab4b5ee3f8bfbbd157a2b93d42845621c72f2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e70b694cadb6a27f0b212b696f211f9c6d705b34026e63cdbd15eab718765a79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e70b694cadb6a27f0b212b696f211f9c6d705b34026e63cdbd15eab718765a79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e70b694cadb6a27f0b212b696f211f9c6d705b34026e63cdbd15eab718765a79"
    sha256 cellar: :any_skip_relocation, sonoma:        "65da1df593e4e9044b5cfd4215d2bd21c2b4024d639dee7e49a612756b556c2f"
    sha256 cellar: :any_skip_relocation, ventura:       "65da1df593e4e9044b5cfd4215d2bd21c2b4024d639dee7e49a612756b556c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e70b694cadb6a27f0b212b696f211f9c6d705b34026e63cdbd15eab718765a79"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~PHP
      <?php echo 'hello brew';
    PHP

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end
