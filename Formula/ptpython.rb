class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/87/82/59e1ca28959b6350a62d90bbb7d19019b3e50fa01a5828936b300d2b46e1/ptpython-3.0.23.tar.gz"
  sha256 "9fc9bec2cc51bc4000c1224d8c56241ce8a406b3d49ec8dc266f78cd3cd04ba4"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae423ad98867ba33d617d85cf0238e8b72593786d6681f195c91679b0d4ad0ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47bba0b5aae615868f735419b935c70c1b97144b95152f9f31f152986b85f6e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5ce664b22e7d3d411812234546d60b2ced4cc1a5295721b15a962366e41271f"
    sha256 cellar: :any_skip_relocation, ventura:        "7c71c1fec1fcd8e5bbf5e9ec04a1990306d07030f2076796b6e1d45bc51140b6"
    sha256 cellar: :any_skip_relocation, monterey:       "d00f080700e6c20c0e8cf3f21278111fa9fa9227d8fb8a43c655758fea327226"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3913be54671d6b1d439ecd379e4352257675a9a28ba9a73e95502ee8d43bd27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415afcca297305d11243407d24ef38fb5b69aa4ff2c3c964739dbf76e86207b4"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/15/02/afd43c5066de05f6b3188f3aa74136a3289e6c30e7a45f351546cab0928c/jedi-0.18.2.tar.gz"
    sha256 "bae794c30d07f6d910d32a7048af09b5a39ed740918da923c6b780790ebac612"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/20/58/bbc8510ed1774ea2879b9996d2783d461c3c612904e230ff6954ce23c694/prompt_toolkit-3.0.37.tar.gz"
    sha256 "d5d73d4b5eb1a92ba884a88962b157f49b71e06c4348b417dd622b25cdd3800b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
