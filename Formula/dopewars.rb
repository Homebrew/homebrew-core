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
    sha256 "8d9aa3ab6faa85c24e9fa3046191b611295785a68f08de5e2d84aa59cdd55713" => :big_sur
    sha256 "0e20a6168f15c6c1245818efc5d5986b77d90d51f184a8e6b06538579d2b8461" => :catalina
    sha256 "85744f87e4866796bf4b06ad280f57542d951ec9498ebf814251448f93e24881" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  uses_from_macos "curl"

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
