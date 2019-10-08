class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.5.tar.gz"
  sha256 "7fdcfc4326b35e384b97bd4bb2189b4cb5cf258948352759c302e632b41bb2e2"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "095c0002a02eadd180c90d25df4e41126d91279dd158eaacc3d67d827b8b9c71" => :mojave
    sha256 "095c0002a02eadd180c90d25df4e41126d91279dd158eaacc3d67d827b8b9c71" => :high_sierra
    sha256 "21d7c565f64aa14388f1993fd66b6e5ebe6f86b367edd6940529dd2c884cb48f" => :sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=python3", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
