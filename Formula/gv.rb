class Gv < Formula
  desc "View and navigate through PostScript and PDF documents"
  homepage "https://www.gnu.org/s/gv/"
  url "https://ftpmirror.gnu.org/gv/gv-3.7.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gv/gv-3.7.4.tar.gz"
  sha256 "2162b3b3a95481d3855b3c4e28f974617eef67824523e56e20b56f12fe201a61"

  depends_on "pkg-config" => :build
  depends_on "ghostscript" => "with-x11"
  depends_on :x11 => "2.7.2"

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
