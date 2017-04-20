class Netpbm < Formula
  desc "Image manipulation"
  homepage "https://netpbm.sourceforge.io/"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/netpbm/code/stable", :revision => 2927
  else
    url "http://svn.code.sf.net/p/netpbm/code/stable", :revision => 2927
  end
  version "10.73.08"
  version_scheme 1

  head "https://svn.code.sf.net/p/netpbm/code/trunk"

  bottle do
    cellar :any
    sha256 "ef3c9771c42cc61c18855222a27fcbe6f0dca58b02c3f597d36306740548b99f" => :sierra
    sha256 "95432b44ddff71e27117d0e5590d062327389fb70e96d976d35329870c0a89ee" => :el_capitan
    sha256 "c96f4ec99ef8df57fbd50cae8fc90b06a915b39cba066cbd51e3b3f8410157c0" => :yosemite
  end

  depends_on "libtiff"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"

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
    assert File.exist?("testing_0_0.")
  end
end
