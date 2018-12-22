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
    sha256 "a26012850a70a3127a039a56b4806b8c1fd003e16ae43b70ba3fbba73510039c" => :mojave
    sha256 "df0f49dc262b0764efbdd53cd0d6c7d256c89e145b27a39731dd371f2ca0fea8" => :high_sierra
    sha256 "d1ad46c6532f218ee0c4bde87ce4e3243d59f4d5f4681bfb71762f6a0a4affd8" => :sierra
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
