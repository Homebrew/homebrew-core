class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.20/psysh-v0.12.20.tar.gz"
  sha256 "2c411b65e83397e966519871e70e8e14aa7d6b2187a9e833a3d42422ac002e7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b2827afdb53c974a2c7db6f619513d4f4a183e1d7b6011a43a63beaf781d3fcb"
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
