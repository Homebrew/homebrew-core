class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.11.0.tar.gz"
  sha256 "5f14ab41508ee9c8756097d6fa81f471fce58089b178317cc25d948d42620994"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git"

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
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=#{Formula["python@3.9"].opt_bin}/python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=#{Formula["python@3.9"].opt_bin}/python3}", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
