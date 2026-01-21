class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.18/psysh-v0.12.18.tar.gz"
  sha256 "47c35f6e966d6d6a42c61d928369a932be4a2154ffcf8670036932f0a885053b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "619f5c3a9dee0b21bfd71f7959f842d868a5bab5f2372612239248ffb9cc5e22"
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
