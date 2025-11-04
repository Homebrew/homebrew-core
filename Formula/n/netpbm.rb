class Netpbm < Formula
  desc "Image manipulation"
  homepage "https://netpbm.sourceforge.net/"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  url "https://svn.code.sf.net/p/netpbm/code/stable", revision: "5109"
  version "11.02.19"
  license "GPL-3.0-or-later"
  revision 1
  version_scheme 1
  head "https://svn.code.sf.net/p/netpbm/code/trunk"

  livecheck do
    url "https://sourceforge.net/p/netpbm/code/HEAD/log/?path=/stable"
    regex(/Release\s+v?(\d+(?:\.\d+)+)/i)
    strategy :page_match
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "4689f74bc56b38c19175186809adbfc7ba5d51903f70ab53cb1f7d1739c4b7d3"
    sha256 arm64_sequoia: "0a63f84f2c4a9852fd19abc7710eafc3d311a41f7e9ac41f76f38ae757689dd3"
    sha256 arm64_sonoma:  "b1441b3a5232d69a63a7ecca8c9a32d9f93459fb772534c4252d06550acaa50e"
    sha256 sonoma:        "1f581585196a99e0095115c54f0a06f85caa58de8389f0b9eed2f21892b50d98"
    sha256 arm64_linux:   "85635e12905266461f184b9771a0316bb42645f46d98719750ecb4c5c72d6217"
    sha256 x86_64_linux:  "531fcef170784145c0bb0601dbdd68aa3c52df883dfbce02b863d76f84689f89"
  end

  depends_on "pkgconf" => :build
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  conflicts_with "jbigkit", because: "both install `pbm.5` and `pgm.5` files"

  resource "html" do
    # Rolling release, latest revision also documents previous software versions
    # NOTE: Keep "revision" and "version" in sync
    url "https://svn.code.sf.net/p/netpbm/code/userguide", revision: "5103"
    version "5103"

    livecheck do
      url "https://sourceforge.net/p/netpbm/code/HEAD/log/?path=/userguide"
      regex(/\[r?(\d+)\]/i)
      strategy :page_match
    end
  end

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
    inreplace "buildtools/manpage.mk", "python", "python3"

    ENV.deparallelize

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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

    # Generate unversioned library symlink (upstream does not do this)
    libnetpbm = lib.glob(shared_library("libnetpbm", "*")).reject(&:symlink?).first.basename
    lib.install_symlink libnetpbm => shared_library("libnetpbm")

    resource("html").stage buildpath/"userguide"
    make_args = %W[
      USERGUIDE=#{buildpath}/userguide
      -f
      #{buildpath}/buildtools/manpage.mk
    ]
    mkdir buildpath/"netpbmdoc" do
      system "make", *make_args, "manpages"
      [man1, man3, man5].map(&:mkpath)
      system "make", "MANDIR=#{man}", *make_args, "installman"
    end
  end

  test do
    fwrite = shell_output("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam")
    (testpath/"test.pam").write fwrite
    system bin/"pamdice", "test.pam", "-outstem", testpath/"testing"
    assert_path_exists testpath/"testing_0_0.pam"
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
