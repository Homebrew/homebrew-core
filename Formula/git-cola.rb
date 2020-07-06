class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.7.tar.gz"
  sha256 "9a1427b05c107ec8337881ed68bb450ac040a08880f91dcb770588f755d6fd1b"
  license "GPL-2.0"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2ec181177165465c80e97a10e54ea4c2f60820b34107a6fca346408865319c6" => :catalina
    sha256 "b2ec181177165465c80e97a10e54ea4c2f60820b34107a6fca346408865319c6" => :mojave
    sha256 "b2ec181177165465c80e97a10e54ea4c2f60820b34107a6fca346408865319c6" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python@3.8"

  uses_from_macos "rsync"

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
