class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.1/psysh-v0.12.1.tar.gz"
  sha256 "8a52efb9e991e5bb85bab02faa87b9399621b5d703339a5549164c2dd2b3cd31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2956acd5f6fa0deceaf2ac02c1d43ecca75f613c67354ee48564de10500b8624"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2956acd5f6fa0deceaf2ac02c1d43ecca75f613c67354ee48564de10500b8624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2956acd5f6fa0deceaf2ac02c1d43ecca75f613c67354ee48564de10500b8624"
    sha256 cellar: :any_skip_relocation, sonoma:         "38acfd2c24e8acabdaabc4dc32ffbcee9456762e833851cc250bb592c981ed70"
    sha256 cellar: :any_skip_relocation, ventura:        "38acfd2c24e8acabdaabc4dc32ffbcee9456762e833851cc250bb592c981ed70"
    sha256 cellar: :any_skip_relocation, monterey:       "38acfd2c24e8acabdaabc4dc32ffbcee9456762e833851cc250bb592c981ed70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2956acd5f6fa0deceaf2ac02c1d43ecca75f613c67354ee48564de10500b8624"
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
