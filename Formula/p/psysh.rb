class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.20/psysh-v0.11.20.tar.gz"
  sha256 "d5dd3bfea13aa9a9ac981924baec4863d620602ef080fdb540373922ef4472fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c29b92967878aa521f7513a54ee50dc8e4f9e4e5733abfcf07750498c826b587"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c29b92967878aa521f7513a54ee50dc8e4f9e4e5733abfcf07750498c826b587"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c29b92967878aa521f7513a54ee50dc8e4f9e4e5733abfcf07750498c826b587"
    sha256 cellar: :any_skip_relocation, ventura:        "4871a3c19623488cceb6f35599fd1d6249c882b455c8f7eccae9dd2c0cbcccc4"
    sha256 cellar: :any_skip_relocation, monterey:       "4871a3c19623488cceb6f35599fd1d6249c882b455c8f7eccae9dd2c0cbcccc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4871a3c19623488cceb6f35599fd1d6249c882b455c8f7eccae9dd2c0cbcccc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4697b4b2f3ef1ddcf3435a6313dac67d3a8b678160fad68589428c66e3e465d"
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
