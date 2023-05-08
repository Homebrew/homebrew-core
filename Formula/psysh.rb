class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.17/psysh-v0.11.17.tar.gz"
  sha256 "190857e2f2f4e7dced0dbe1ea9c635af78dd412f20424690efff8d311e231f63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6417c877e1c49c7a328664217aa8f21b0f9a02c345c99dbc1505484b119ada96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6417c877e1c49c7a328664217aa8f21b0f9a02c345c99dbc1505484b119ada96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6417c877e1c49c7a328664217aa8f21b0f9a02c345c99dbc1505484b119ada96"
    sha256 cellar: :any_skip_relocation, ventura:        "22ff1cedaeb2ee7ecaffb8b3dfea42e90cb7c63ce8ccae8b5c77ed7aab307783"
    sha256 cellar: :any_skip_relocation, monterey:       "22ff1cedaeb2ee7ecaffb8b3dfea42e90cb7c63ce8ccae8b5c77ed7aab307783"
    sha256 cellar: :any_skip_relocation, big_sur:        "22ff1cedaeb2ee7ecaffb8b3dfea42e90cb7c63ce8ccae8b5c77ed7aab307783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6417c877e1c49c7a328664217aa8f21b0f9a02c345c99dbc1505484b119ada96"
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
