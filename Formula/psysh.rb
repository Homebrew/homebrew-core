class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.12/psysh-v0.11.12.tar.gz"
  sha256 "726041f2dd45fe14c96dff604602b363428e9e507d43ddbb7d90ea841d236c0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a6e4a639a3f87fededd795c378aa896abe85b03985c9f451bcf03593256ec63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a6e4a639a3f87fededd795c378aa896abe85b03985c9f451bcf03593256ec63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a6e4a639a3f87fededd795c378aa896abe85b03985c9f451bcf03593256ec63"
    sha256 cellar: :any_skip_relocation, ventura:        "c54f09d5f4133056580edf5a85069432fb34b551b217ed5006636a19b8baa3de"
    sha256 cellar: :any_skip_relocation, monterey:       "c54f09d5f4133056580edf5a85069432fb34b551b217ed5006636a19b8baa3de"
    sha256 cellar: :any_skip_relocation, big_sur:        "c54f09d5f4133056580edf5a85069432fb34b551b217ed5006636a19b8baa3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6e4a639a3f87fededd795c378aa896abe85b03985c9f451bcf03593256ec63"
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
