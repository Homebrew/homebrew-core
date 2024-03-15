class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.1/psysh-v0.12.1.tar.gz"
  sha256 "8a52efb9e991e5bb85bab02faa87b9399621b5d703339a5549164c2dd2b3cd31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dba2a82df66019ee916322892dc97b2a40f17e6d18c13894a3459430e330aeb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dba2a82df66019ee916322892dc97b2a40f17e6d18c13894a3459430e330aeb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dba2a82df66019ee916322892dc97b2a40f17e6d18c13894a3459430e330aeb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "62c7255fe2543e264376cc422ce97b292b9c840bca198b0a4f142e3eb19aa852"
    sha256 cellar: :any_skip_relocation, ventura:        "62c7255fe2543e264376cc422ce97b292b9c840bca198b0a4f142e3eb19aa852"
    sha256 cellar: :any_skip_relocation, monterey:       "62c7255fe2543e264376cc422ce97b292b9c840bca198b0a4f142e3eb19aa852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dba2a82df66019ee916322892dc97b2a40f17e6d18c13894a3459430e330aeb8"
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
