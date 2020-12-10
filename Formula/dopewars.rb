class Dopewars < Formula
  desc 'Free rewrite of a game originally based on "Drug Wars"'
  homepage "https://dopewars.sourceforge.io"
  url "https://downloads.sourceforge.net/project/dopewars/dopewars/1.6.0/dopewars-1.6.0.tar.gz"
  sha256 "f8543d6cb73074a63c75409a60e8c739bc6cf121328f939f99ac86df2fe89d3d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "ff4f79046cbffb1d786f4acd203d7bcbc369b929e603011e3f64ce6c22a29339" => :big_sur
    sha256 "f2e1a3e2e6199fc550af9afc8204b0292a34976f85ec2448fee549b434048c34" => :catalina
    sha256 "8bb4cbd11a3db0bbdbdd283d531742c9485dc1d86b57b9986f3b86da01947807" => :mojave
    sha256 "3808bf43bb96b796624f8ffb855b176ea2a908f3b9477fd7d07a1f960dff0ef2" => :high_sierra
    sha256 "db1c91122cf53f166a5811595bbf84b63227818ca11877b78a21592686a975f2" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    inreplace "src/Makefile.in", "$(dopewars_DEPENDENCIES)", ""
    inreplace "auxbuild/ltmain.sh", "need_relink=yes", "need_relink=no"
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
