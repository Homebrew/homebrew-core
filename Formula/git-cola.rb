class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.9.tar.gz"
  sha256 "66b62f479ad141322351d62aff76e4882719d08f8f29b35f97d30f355391a54e"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9a2de2f11aa72f0c4010a89c0118974cca4aed743bd8809cac81d6839a35bb2"
    sha256 cellar: :any_skip_relocation, big_sur:       "54c0806c423ffadb4bf4e017d8e7b657f0636fd16055e174bdf98881ccbb0ed0"
    sha256 cellar: :any_skip_relocation, catalina:      "8ba8892158a9e2ceef9f278b4c7a789a2ee26bfffce97c56863d287a5b56d071"
    sha256 cellar: :any_skip_relocation, mojave:        "ad020b9751ad02ff662b94c1df5bb18a496ec77c46957d6ec200633b45bf2959"
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
