class Netpbm < Formula
  desc "Image manipulation"
  homepage "http://netpbm.sourceforge.net"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for versions and matching revisions
  url "http://svn.code.sf.net/p/netpbm/code/advanced", :revision => 2825
  version "10.76"
  head "http://svn.code.sf.net/p/netpbm/code/trunk"

  bottle do
    cellar :any
    sha256 "8a2d966ab4668144f3f9ebaf69b170e9efa81ce399dc6d26977b953d7be2b44f" => :sierra
    sha256 "a592a25f28c8f150f16e73e6c72c7fa5c91feccf2948c1fe2d9e3e558b793785" => :el_capitan
    sha256 "17a4e01fbf68d771b2a862a6279d2e61d1f9e9a683ed4c03b16eb21214ecd7f7" => :yosemite
  end

  option :universal

  depends_on "libtiff"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"

  def install
    ENV.universal_binary if build.universal?

    cp "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
      s.change_make_var! "NETPBMLIBTYPE", "dylib"
      s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
      s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{Formula["jasper"].opt_include}/jasper"
    end

    ENV.deparallelize
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"

    cd "stage" do
      inreplace "pkgconfig_template" do |s|
        s.gsub! "@VERSION@", File.read("VERSION").sub("Netpbm ", "").chomp
        s.gsub! "@LINKDIR@", lib
        s.gsub! "@INCLUDEDIR@", include
      end

      prefix.install %w[bin include lib misc]
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir["man/man1/*.1"]
      man5.install Dir["man/man5/*.5"]
      lib.install Dir["link/*.a"]
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end

    (bin/"doc.url").unlink
  end

  test do
    fwrite = Utils.popen_read("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam")
    (testpath/"test.pam").write fwrite
    system "#{bin}/pamdice", "test.pam", "-outstem", testpath/"testing"
    assert File.exist?("testing_0_0.")
  end
end
