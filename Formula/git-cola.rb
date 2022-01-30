class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.12.0.tar.gz"
  sha256 "ec1167ea9a472214bf18f5537d96e137c724f3d28a85b3642f07dba35f04b24a"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e32f65fad03f9c1c918ce61a206cf37f94b239cc69a5cc511288d8e887fe184"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e32f65fad03f9c1c918ce61a206cf37f94b239cc69a5cc511288d8e887fe184"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c1907cb8948842c6fda3df753ceb726f3b28fe59d07f4f7fd3915717b7c213c"
    sha256 cellar: :any_skip_relocation, catalina:       "5c1907cb8948842c6fda3df753ceb726f3b28fe59d07f4f7fd3915717b7c213c"
    sha256 cellar: :any_skip_relocation, mojave:         "5c1907cb8948842c6fda3df753ceb726f3b28fe59d07f4f7fd3915717b7c213c"
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt@5"
  depends_on "python@3.9"

  uses_from_macos "rsync"

  def install
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    # Remove when disutils is no longer used: https://github.com/git-cola/git-cola/issues/1201
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    ENV.delete("PYTHONPATH")
    ENV["PYTHON"] = which("python3")
    system "make", "prefix=#{prefix}", "install"
    system "make", "install-doc", "prefix=#{prefix}", "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system bin/"git-cola", "--version"
  end
end
