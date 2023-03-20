class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.12/psysh-v0.11.12.tar.gz"
  sha256 "726041f2dd45fe14c96dff604602b363428e9e507d43ddbb7d90ea841d236c0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e1c5ac589d76ecf33aca97295e2fe338624261cdd05243d9340eb201d75680d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1c5ac589d76ecf33aca97295e2fe338624261cdd05243d9340eb201d75680d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e1c5ac589d76ecf33aca97295e2fe338624261cdd05243d9340eb201d75680d"
    sha256 cellar: :any_skip_relocation, ventura:        "7f338278e4470fb1a72dcc536f4bc025ded98925a341845b142c4c3b97303fed"
    sha256 cellar: :any_skip_relocation, monterey:       "7f338278e4470fb1a72dcc536f4bc025ded98925a341845b142c4c3b97303fed"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f338278e4470fb1a72dcc536f4bc025ded98925a341845b142c4c3b97303fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e1c5ac589d76ecf33aca97295e2fe338624261cdd05243d9340eb201d75680d"
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
