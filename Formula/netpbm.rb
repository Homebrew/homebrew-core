class Netpbm < Formula
  desc "Image manipulation"
  homepage "https://netpbm.sourceforge.io/"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/netpbm/code/stable", :revision => 3079
  else
    url "http://svn.code.sf.net/p/netpbm/code/stable", :revision => 3079
  end
  version "10.73.16"
  version_scheme 1

  head "https://svn.code.sf.net/p/netpbm/code/trunk"

  bottle do
    cellar :any
    sha256 "babaf6a816aa3314583b0892bda37efc2a39227ad20e03994fbaad1ae06d7d5e" => :high_sierra
    sha256 "dfd98f92f53f38a8f6e98ab64c132c9f92f8e33228f9784c42909cac13ca9705" => :sierra
    sha256 "433f9816c644f9282abd1b7290d8e0e0cf5f8c1090a36a8899471eaa8b3a2398" => :el_capitan
  end

  depends_on "libtiff"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"

  conflicts_with "jbigkit", :because => "both install `pbm.5` and `pgm.5` files"

  def install
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
