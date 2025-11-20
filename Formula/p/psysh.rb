class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.14/psysh-v0.12.14.tar.gz"
  sha256 "e384531884739d79dec8f1c7efaeff68e2124eee0ffc6547f27e8f049068b56a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9daf51688dcb0b101cb606195fc789ec24baa35de1a7bb4e093b66e5553ae435"
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
