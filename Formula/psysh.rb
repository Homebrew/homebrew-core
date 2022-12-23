class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.10/psysh-v0.11.10.tar.gz"
  sha256 "d94f47300dce000f4d97d2552637a9076be2d0ee3cdf11a9afc9d050684eae92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8373b270f93f7d9fa9495ff18c4915bf5b240865e4f3ac0b6b47111e4d6138b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8373b270f93f7d9fa9495ff18c4915bf5b240865e4f3ac0b6b47111e4d6138b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8373b270f93f7d9fa9495ff18c4915bf5b240865e4f3ac0b6b47111e4d6138b0"
    sha256 cellar: :any_skip_relocation, ventura:        "41fcd007b1dcbf3f549ae67d95f6599cb8b798122ca60505c4aabe8c5e76a390"
    sha256 cellar: :any_skip_relocation, monterey:       "41fcd007b1dcbf3f549ae67d95f6599cb8b798122ca60505c4aabe8c5e76a390"
    sha256 cellar: :any_skip_relocation, big_sur:        "41fcd007b1dcbf3f549ae67d95f6599cb8b798122ca60505c4aabe8c5e76a390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8373b270f93f7d9fa9495ff18c4915bf5b240865e4f3ac0b6b47111e4d6138b0"
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
