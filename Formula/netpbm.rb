class Netpbm < Formula
  desc "Image manipulation"
  homepage "https://netpbm.sourceforge.io/"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  url "https://svn.code.sf.net/p/netpbm/code/stable", revision: "4534"
  version "10.86.38"
  license "GPL-3.0-or-later"
  revision 1
  version_scheme 1
  head "https://svn.code.sf.net/p/netpbm/code/trunk"

  livecheck do
    url "https://sourceforge.net/p/netpbm/code/HEAD/log/?path=/stable"
    regex(/Release\s+v?(\d+(?:\.\d+)+)/i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "9ff16b71c6348e3942f637886f45e5b07b27357056d587b4d2484380d90fdd97"
    sha256 arm64_monterey: "1d68b2864f75de77f1acee7cb97445ee175115cc6d03164d09381b184bb61e16"
    sha256 arm64_big_sur:  "e5f94b26bd98fc1777d791044b0cfe8fe15d251f89d5c21a6a126617c8d25af7"
    sha256 ventura:        "23182fe0629870931c9ef21421a30896ed42c9b1300696779d9ec415977dcb41"
    sha256 monterey:       "99818b30ee4b6ed3f70b2a6d5a3e11082a5f4ebd196c9aeb45c54ada94bc1702"
    sha256 big_sur:        "68867880d23ac8fec178025a70390c43aafb1db7d8d4af782e0cff3686d724d6"
    sha256 x86_64_linux:   "fdf9b76989406e9a48304722230113c69d8a1b7ec6c0843d0ef6adea18ceafde"
  end

  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "flex" => :build
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  conflicts_with "jbigkit", because: "both install `pbm.5` and `pgm.5` files"

  def install
    cp "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", Formula["jasper"].opt_include/"jasper"
      s.gsub! "/usr/local/netpbm/rgb.txt", prefix/"misc/rgb.txt"

      if OS.mac?
        s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
        s.change_make_var! "NETPBMLIBTYPE", "dylib"
        s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
        s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      else
        s.change_make_var! "CFLAGS_SHLIB", "-fPIC"
      end
    end

    ENV.deparallelize
    ENV.append_to_cflags "-Wno-implicit-function-declaration" # Workaround for Xcode 14.3.
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"

    cd "stage" do
      inreplace "pkgconfig_template" do |s|
        s.gsub! "@VERSION@", File.read("VERSION").sub("Netpbm ", "").chomp
        s.gsub! "@LINKDIR@", lib
        s.gsub! "@INCLUDEDIR@", include
      end

      prefix.install %w[bin include lib misc]
      lib.install buildpath.glob("staticlink/*.a"), buildpath.glob("sharedlink/#{shared_library("*")}")
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end

    # We don't run `make install`, so an unversioned library symlink is never generated.
    # FIXME: Check whether we can call `make install` instead of creating this manually.
    libnetpbm = lib.glob(shared_library("libnetpbm", "*")).reject(&:symlink?).first.basename
    lib.install_symlink libnetpbm => shared_library("libnetpbm")
  end

  test do
    fwrite = shell_output("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam")
    (testpath/"test.pam").write fwrite
    system bin/"pamdice", "test.pam", "-outstem", testpath/"testing"
    assert_predicate testpath/"testing_0_0.pam", :exist?
    (testpath/"test.xpm").write <<~EOS
      /* XPM */
      static char * favicon_xpm[] = {
      "16 16 4 1",
      " 	c white",
      ".	c blue",
      "X	c black",
      "o	c red",
      "                ",
      "                ",
      "                ",
      "                ",
      "  ....    ....  ",
      " .    .  .    . ",
      ".  ..  ..  ..  .",
      "  .  . .. .  .  ",
      " .   XXXXXX   . ",
      " .   XXXXXX   . ",
      "oooooooooooooooo",
      "oooooooooooooooo",
      "oooooooooooooooo",
      "oooooooooooooooo",
      "XXXXXXXXXXXXXXXX",
      "XXXXXXXXXXXXXXXX"};
    EOS
    ppmout = shell_output("#{bin}/xpmtoppm test.xpm")
    refute_predicate ppmout, :empty?
  end
end
