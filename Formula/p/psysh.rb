class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.12/psysh-v0.12.12.tar.gz"
  sha256 "a8342dbf7508eec69b3dca78a8a2703fc22c3818e11581dba177a445d414802e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ebe835edc2e4b25b2787f7e888f5c93d07af8b1fa4b0a294bd96a09b258d1724"
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
