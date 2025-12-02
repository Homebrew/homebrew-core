class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.15/psysh-v0.12.15.tar.gz"
  sha256 "e1e1c666298733638b783fc98ae1c1f8aa6b39d6dffe5c6868a8fefb3873053b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3e2da578b61bc59cbde4b2fe0f391b4526d60cc4115fe4b73caf165f9d45e21"
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
