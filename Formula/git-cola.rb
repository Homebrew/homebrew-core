class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.10.1.tar.gz"
  sha256 "1d7a9be54e66fcaa49585cda3ec89b6b2448f6e38c6f41047e55ecaff2d809d3"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "59bb04e27ae81985b641c0d6bf886d538ec0d4eca3e38681cba0479e76a2064a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7c75d4c5c2b43d3f2b2fb57b9f26e0d95933e2b94dc2b6cf7e24ea8b91a5da6"
    sha256 cellar: :any_skip_relocation, catalina:      "a7c75d4c5c2b43d3f2b2fb57b9f26e0d95933e2b94dc2b6cf7e24ea8b91a5da6"
    sha256 cellar: :any_skip_relocation, mojave:        "a7c75d4c5c2b43d3f2b2fb57b9f26e0d95933e2b94dc2b6cf7e24ea8b91a5da6"
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
