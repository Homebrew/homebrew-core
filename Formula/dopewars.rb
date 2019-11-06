class Dopewars < Formula
  desc 'Free rewrite of a game originally based on "Drug Wars"'
  homepage "https://dopewars.sourceforge.io"
  url "https://downloads.sourceforge.net/project/dopewars/dopewars/1.5.12/dopewars-1.5.12.tar.gz"
  sha256 "23059dcdea96c6072b148ee21d76237ef3535e5be90b3b2d8239d150feee0c19"
  revision 1

  bottle do
    sha256 "f2e1a3e2e6199fc550af9afc8204b0292a34976f85ec2448fee549b434048c34" => :catalina
    sha256 "8bb4cbd11a3db0bbdbdd283d531742c9485dc1d86b57b9986f3b86da01947807" => :mojave
    sha256 "3808bf43bb96b796624f8ffb855b176ea2a908f3b9477fd7d07a1f960dff0ef2" => :high_sierra
    sha256 "db1c91122cf53f166a5811595bbf84b63227818ca11877b78a21592686a975f2" => :sierra
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
