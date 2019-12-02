class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.6.tar.gz"
  sha256 "63369f519f81988c2d167ba2c59ad53644d3fac2b7be1e12d3f1df9b8fd91839"
  revision 2
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9298661d78219de2ad1a621a76d4c3785d10fb7abd4606d38e195573cd01c541" => :catalina
    sha256 "9298661d78219de2ad1a621a76d4c3785d10fb7abd4606d38e195573cd01c541" => :mojave
    sha256 "9298661d78219de2ad1a621a76d4c3785d10fb7abd4606d38e195573cd01c541" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python@3.8"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=#{Formula["python@3.8"].opt_bin}/python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=#{Formula["python@3.8"].opt_bin}/python3}", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
