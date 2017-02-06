class Dopewars < Formula
  desc 'Free rewrite of a game originally based on "Drug Wars"'
  homepage "http://dopewars.sourceforge.net"
  url "https://downloads.sourceforge.net/project/dopewars/dopewars/1.5.12/dopewars-1.5.12.tar.gz"
  sha256 "23059dcdea96c6072b148ee21d76237ef3535e5be90b3b2d8239d150feee0c19"

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    inreplace "src/Makefile.in", "$(dopewars_DEPENDENCIES)", ""
    inreplace "ltmain.sh", "need_relink=yes", "need_relink=no"
    inreplace "src/plugins/Makefile.in", "LIBADD =", "LIBADD = -module -avoid-version"
    system "./configure", "--disable-gui-client",
                          "--disable-gui-server",
                          "--enable-plugins",
                          "--enable-networking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/dopewars", "-v"
  end
end
