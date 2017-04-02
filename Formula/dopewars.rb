class Dopewars < Formula
  desc 'Free rewrite of a game originally based on "Drug Wars"'
  homepage "https://dopewars.sourceforge.io"
  url "https://downloads.sourceforge.net/project/dopewars/dopewars/1.5.12/dopewars-1.5.12.tar.gz"
  sha256 "23059dcdea96c6072b148ee21d76237ef3535e5be90b3b2d8239d150feee0c19"

  bottle do
    sha256 "2cd2bcd5c69422ea725622831b054ce4d75656f085e7e919d2a5a055fed30037" => :sierra
    sha256 "019168fe18bb28f596bad5858bfd782473800920d9bb5cf71ce94ac90c4fcf5d" => :el_capitan
    sha256 "282643cc528cca8f01101c4f908e07889585c07d60b2da31fde88b41a07c1c2c" => :yosemite
  end

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
