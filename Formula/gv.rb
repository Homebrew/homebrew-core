class Gv < Formula
  desc "View and navigate through PostScript and PDF documents"
  homepage "https://www.gnu.org/s/gv/"
  url "https://ftp.gnu.org/gnu/gv/gv-3.7.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gv/gv-3.7.4.tar.gz"
  sha256 "2162b3b3a95481d3855b3c4e28f974617eef67824523e56e20b56f12fe201a61"

  bottle do
    sha256 "69fbb73f62983b7bfaa109ec330641de0e5786de2c3ecc373056153262e2373a" => :mojave
    sha256 "afc07271447c8455ac3313775832a1aa264245436b16f0333a4b7dddaf32d702" => :high_sierra
    sha256 "ae08a48cf7464fbf8af390ac017646cfa986fd95447ed8af5b91687350e10c93" => :sierra
    sha256 "80956fd9b222cb9185517f3bb2809d93fd23a8acff70e0bbb9e295cc3b54725b" => :el_capitan
    sha256 "aabf19a4073bae6b5b337c595169f18a3c4af9157bfcbd2b9b15744c3d0e4f2c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript" => "with-x11"
  depends_on :x11

  skip_clean "share/gv/safe-gs-workdir"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-SIGCHLD-fallback"
    system "make", "install"
  end

  test do
    system "#{bin}/gv", "--version"
  end
end
