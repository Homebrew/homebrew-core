class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "https://djvu.sourceforge.io/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.12/djview-4.12.tar.gz"
  sha256 "5673c6a8b7e195b91a1720b24091915b8145de34879db1158bc936b100eaf3e3"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/djview[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "e649d68385bba4e58504c3fb4576367125dfff5717b4f6405bca35086ba9bed7"
    sha256 cellar: :any, catalina: "0a01bfd959f758987d9c4dd25e01e57532dd11279fa0d562876fc0927138e788"
    sha256 cellar: :any, mojave:   "a1f4b788b946b22bbc4c9c3811dbb1db1827c78188dbbd79563cfd5d415ac01b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "qt@5"

  def install
    system "autoreconf", "-fiv"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-nsdejavu",
                          "--disable-desktopfiles"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"

    # From the djview4.8 README:
    # NOTE: Do not use command "make install".
    # Simply copy the application bundle where you want it.
    on_macos do
      prefix.install "src/djview.app"
      bin.write_exec_script prefix/"djview.app/Contents/MacOS/djview"
    end
    on_linux do
      prefix.install "src/djview"
    end
  end

  test do
    assert_predicate prefix/"djview.app", :exist?
  end
end
