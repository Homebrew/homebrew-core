class Netpbm < Formula
  desc "Image manipulation"
  homepage "https://netpbm.sourceforge.net/"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  url "https://svn.code.sf.net/p/netpbm/code/stable", revision: "5149"
  version "11.02.20"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://svn.code.sf.net/p/netpbm/code/trunk"

  livecheck do
    url "https://sourceforge.net/p/netpbm/code/HEAD/log/?path=/stable"
    regex(/Release\s+v?(\d+(?:\.\d+)+)/i)
    strategy :page_match
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "1307826f2e0f6e86b7393279d4fe779a3f8e858f4029cca6344b4dac39981bf5"
    sha256 arm64_sequoia: "5657077958fa994e7a8cfa6e549e672ba112ceaf985efe9948abbae43b8fd73e"
    sha256 arm64_sonoma:  "696661f0ec8d34a21862bab9ad51b1ce8dffdcd826ea4a081967c89010e7c979"
    sha256 sonoma:        "8ec7d68d1e668fbde0615b9534c2c169af47525874f87ff771d4e3242773a95d"
    sha256 arm64_linux:   "1d53758c8c0ecb88150798ac1cb67b61a349b1403810ab82dfc5bef148aaa1e1"
    sha256 x86_64_linux:  "545e5b5ac8c34863ade93bb2dd22be7224dc2aa76fc5538d4975a5a238ddd151"
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
    url "https://svn.code.sf.net/p/netpbm/code/userguide", revision: "5143"
    version "5143"

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
