class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.22/psysh-v0.11.22.tar.gz"
  sha256 "2db70222b2eae83bda07a7799490708a2934033418cf8b191ef295dc46b533ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9395f9f2debae156a41d6913eae3c23fc5f9ce2b200a9d787cfd5088d2c217b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9395f9f2debae156a41d6913eae3c23fc5f9ce2b200a9d787cfd5088d2c217b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9395f9f2debae156a41d6913eae3c23fc5f9ce2b200a9d787cfd5088d2c217b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "75b40ec5e86d782a9342c7a96c4c53742dc0966a65c193ea4ab53c3349f089ad"
    sha256 cellar: :any_skip_relocation, ventura:        "75b40ec5e86d782a9342c7a96c4c53742dc0966a65c193ea4ab53c3349f089ad"
    sha256 cellar: :any_skip_relocation, monterey:       "75b40ec5e86d782a9342c7a96c4c53742dc0966a65c193ea4ab53c3349f089ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9395f9f2debae156a41d6913eae3c23fc5f9ce2b200a9d787cfd5088d2c217b4"
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
