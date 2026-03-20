class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.21/psysh-v0.12.21.tar.gz"
  sha256 "603f8049c3514c7be4277ca919ad5f43ed48196366dc6606b5919fda48bf0040"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "baab9b328cb38cdad5e25e64e59eabcf7796ab6fb536f5add7d2f8bb5ad5979a"
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
