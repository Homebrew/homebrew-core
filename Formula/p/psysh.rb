class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.21/psysh-v0.11.21.tar.gz"
  sha256 "b6e82d64ea94def2e82b6da8773c6ce848c3165ae398108ca66df6a369625639"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ed5e7d0a0c3ac047e6d61c8353b3992345ceaf7ce8d4d8a56eea9bb684d62cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ed5e7d0a0c3ac047e6d61c8353b3992345ceaf7ce8d4d8a56eea9bb684d62cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ed5e7d0a0c3ac047e6d61c8353b3992345ceaf7ce8d4d8a56eea9bb684d62cd"
    sha256 cellar: :any_skip_relocation, ventura:        "7e9b57fb83866794e576ef188e0a377753319ddef7622d3571bed01272e3788c"
    sha256 cellar: :any_skip_relocation, monterey:       "7e9b57fb83866794e576ef188e0a377753319ddef7622d3571bed01272e3788c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e9b57fb83866794e576ef188e0a377753319ddef7622d3571bed01272e3788c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed5e7d0a0c3ac047e6d61c8353b3992345ceaf7ce8d4d8a56eea9bb684d62cd"
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
