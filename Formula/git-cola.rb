class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.10.1.tar.gz"
  sha256 "1d7a9be54e66fcaa49585cda3ec89b6b2448f6e38c6f41047e55ecaff2d809d3"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "de0f152dfbf8c6ea1c381779a74766f361386e7fe638e75f45a125d743f76bbe"
    sha256 cellar: :any_skip_relocation, big_sur:       "deb9ba8da075147d69c7986c5f56b177435ecf2c2dd8de7f102d7cdc95efede3"
    sha256 cellar: :any_skip_relocation, catalina:      "deb9ba8da075147d69c7986c5f56b177435ecf2c2dd8de7f102d7cdc95efede3"
    sha256 cellar: :any_skip_relocation, mojave:        "deb9ba8da075147d69c7986c5f56b177435ecf2c2dd8de7f102d7cdc95efede3"
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt@5"
  depends_on "python@3.9"

  uses_from_macos "rsync"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=#{Formula["python@3.9"].opt_bin}/python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=#{Formula["python@3.9"].opt_bin}/python3}", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
