class Netpbm < Formula
  desc "Image manipulation"
  homepage "https://netpbm.sourceforge.io/"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  url "https://svn.code.sf.net/p/netpbm/code/stable", revision: "4259"
  version "10.86.30"
  license "GPL-3.0-or-later"
  revision 1
  version_scheme 1
  head "https://svn.code.sf.net/p/netpbm/code/trunk"

  livecheck do
    url "https://sourceforge.net/p/netpbm/code/HEAD/tree/stable/"
    strategy :page_match
    regex(/Release v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e0a7b3c51122bde5dcf7b8276ba06592fd72abd88286f52b9f91dcfb8f51a367"
    sha256 cellar: :any,                 arm64_big_sur:  "598183f3f18a4ab25d74ec77fa0ac33b07fa14450fe8aa88e9844c5197645f67"
    sha256 cellar: :any,                 monterey:       "38ffa6a5e288c0e1f46012e488c79b98edaa62e8b0d23bda3ac17c775cacbc69"
    sha256 cellar: :any,                 big_sur:        "ebbe65bb2e16566d63123924aecf3a5f4a04e3a4a11d570d8580ed9de2c05729"
    sha256 cellar: :any,                 catalina:       "fc8cb5599fcc055914f810e006c55cfd5972ad6a845d54fa4400bd97e73e4e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e59b5b70b14eab120497bb68de64d5598570c6a509c48514c3da54aabe5212d0"
  end

  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "flex" => :build
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  conflicts_with "jbigkit", because: "both install `pbm.5` and `pgm.5` files"

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

    cp "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{Formula["jasper"].opt_include}/jasper"

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
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"

    cd "stage" do
      inreplace "pkgconfig_template" do |s|
        s.gsub! "@VERSION@", File.read("VERSION").sub("Netpbm ", "").chomp
        s.gsub! "@LINKDIR@", lib
        s.gsub! "@INCLUDEDIR@", include
      end

      prefix.install %w[bin include lib misc]
      lib.install Dir["staticlink/*.a"], Dir["sharedlink/#{shared_library("*")}"]
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end
  end

  test do
    fwrite = shell_output("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam")
    (testpath/"test.pam").write fwrite
    system "#{bin}/pamdice", "test.pam", "-outstem", testpath/"testing"
    assert_predicate testpath/"testing_0_0.", :exist?
  end
end
