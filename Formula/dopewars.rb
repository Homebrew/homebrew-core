class Dopewars < Formula
  desc 'Free rewrite of a game originally based on "Drug Wars"'
  homepage "https://dopewars.sourceforge.io"
  url "https://downloads.sourceforge.net/project/dopewars/dopewars/1.5.12/dopewars-1.5.12.tar.gz"
  sha256 "23059dcdea96c6072b148ee21d76237ef3535e5be90b3b2d8239d150feee0c19"

  bottle do
    sha256 "4f3ddc708a41e33de69e23a625f40582edc8510c66bafd144eb6a20cb8d54fb9" => :mojave
    sha256 "86b78c8cee8505ad3bde0e2d52bf45a60ac388735c034a1450d3be1117937749" => :high_sierra
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
