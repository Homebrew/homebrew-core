class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.12.0.tar.gz"
  sha256 "ec1167ea9a472214bf18f5537d96e137c724f3d28a85b3642f07dba35f04b24a"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "764ca702d38688dcabb5c4b9f66a7f22c75a459d3f6b8958dcf9774878f2180d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "764ca702d38688dcabb5c4b9f66a7f22c75a459d3f6b8958dcf9774878f2180d"
    sha256 cellar: :any_skip_relocation, monterey:       "209da4235803549d7c09ed2a0a52cf318691da57646e36c97eec54663f38eab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "209da4235803549d7c09ed2a0a52cf318691da57646e36c97eec54663f38eab5"
    sha256 cellar: :any_skip_relocation, catalina:       "209da4235803549d7c09ed2a0a52cf318691da57646e36c97eec54663f38eab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b7d769c22c41700d9813222188aca1bfe1f0971526590ad98da4c666059e0b4"
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
