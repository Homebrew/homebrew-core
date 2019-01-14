class Netpbm < Formula
  desc "Image manipulation"
  homepage "https://netpbm.sourceforge.io/"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  url "http://svn.code.sf.net/p/netpbm/code/stable", :revision => 3459
  version "10.73.24"
  version_scheme 1
  head "http://svn.code.sf.net/p/netpbm/code/trunk"

  bottle do
    cellar :any
    sha256 "6759f09dd406949059bab04a38b4e697cdfd1184aed2f26b11a306e3283b098e" => :mojave
    sha256 "6ab5e513e4bf75ae40907a042d119d5816f40c97ac3c34cfe5981208f1d55dde" => :high_sierra
    sha256 "339679dc504fe630c341c12d96386bc8a0456dc89cf3459166b31ebb8c039e0a" => :sierra
  end

  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  conflicts_with "jbigkit", :because => "both install `pbm.5` and `pgm.5` files"

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

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
      lib.install Dir["link/*.a"], Dir["link/*.dylib"]
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end

    (bin/"doc.url").unlink
  end

  test do
    fwrite = Utils.popen_read("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam")
    (testpath/"test.pam").write fwrite
    system "#{bin}/pamdice", "test.pam", "-outstem", testpath/"testing"
    assert_predicate testpath/"testing_0_0.", :exist?
  end
end
