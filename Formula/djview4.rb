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
    rebuild 1
    sha256 cellar: :any, big_sur:  "e9764b18d1b3a47b052ed924c09f36b31428b429dce1aaa7ade4e679f1c52339"
    sha256 cellar: :any, catalina: "f77e017d7a0acdfbdadf62c2e5773b254d72691f9e51301fb91130ea3cb3d42a"
    sha256 cellar: :any, mojave:   "03517ea84af4e35f7997e7e5a25bee8c786d9ca3ef8a681066405ef31304e031"
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
    if OS.mac?
      prefix.install "src/djview.app"
      bin.write_exec_script prefix/"djview.app/Contents/MacOS/djview"
    else
      prefix.install "src/djview"
    end
  end

  test do
    on_macos do
      assert_predicate prefix/"djview.app", :exist?
    end
    on_linux do
      assert_predicate prefix/"djview", :exist?
    end
  end
end
