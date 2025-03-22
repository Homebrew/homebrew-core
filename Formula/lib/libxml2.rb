class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  license "MIT"
  revision 1

  stable do
    url "https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.6.tar.xz"
    sha256 "f453480307524968f7a04ec65e64f2a83a825973bcd260a2e7691be82ae70c96"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Fix pkg-config checks for libicuuc. Patch taken from:
    # https://gitlab.gnome.org/GNOME/libxml2/-/commit/b57e022d75425ef8b617a1c3153198ee0a941da8
    # When the patch is no longer needed, remove along with the `stable` block
    # and the autotools dependencies above. Also uncomment `if build.head?`
    # condition in the `install` block.
    patch :DATA
  end

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia: "f585e030571f81a1755b03d29bfd9d0751e45ab36f8d2b21ad8674fcd821c32e"
    sha256                               arm64_sonoma:  "581829bae5e41b8255c530e4845d57314cfead278eb85b8f922c7da3ede3fa41"
    sha256                               arm64_ventura: "f52ef9fe5284f43672911d133b9fbb0e8b6f320a884f859df8a607a928e732f2"
    sha256                               sonoma:        "47fc0fcaf1ea2b1979efbec0668613b3945fc56fd9a6b3d51215dc86b45e1892"
    sha256                               ventura:       "c0d736a8dcbe532c843d604c503cf44a7c29be803ae3533c7588b96b7cef58ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "671e23441aa348a1050ed35c58af3e1071fdd71910867c9b437d27c8e5a75370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891911ca6d5116f17ad419581a45cc29d6679326902e986926015e6751783c00"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "icu4c@77"
  depends_on "readline"

  uses_from_macos "zlib"

  def icu4c
    deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
        .to_formula
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # Work around build failure due to icu4c 75+ adding -std=c11 to installed
    # files when built without manually setting "-std=" in CFLAGS. This causes
    # issues on Linux for `libxml2` as `addrinfo` needs GNU extensions.
    # nanohttp.c:1019:42: error: invalid use of undefined type 'struct addrinfo'
    ENV.append "CFLAGS", "-std=gnu11" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" # if build.head?
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--enable-static",
                          "--with-history",
                          "--with-http",
                          "--with-icu",
                          "--with-legacy", # https://gitlab.gnome.org/GNOME/libxml2/-/issues/751#note_2157870
                          "--without-lzma",
                          "--without-python",
                          *std_configure_args
    system "make", "install"

    inreplace [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"] do |s|
      s.gsub! prefix, opt_prefix
      s.gsub! icu4c.prefix.realpath, icu4c.opt_prefix, audit_result: false
    end

    # `icu4c` is keg-only, so we need to tell `pkg-config` where to find its
    # modules.
    if OS.mac?
      icu_uc_pc = icu4c.opt_lib/"pkgconfig/icu-uc.pc"
      inreplace lib/"pkgconfig/libxml-2.0.pc",
                /^Requires\.private:(.*)\bicu-uc\b(.*)$/,
                "Requires.private:\\1#{icu_uc_pc}\\2"
    end

    sdk_include = if OS.mac?
      sdk = MacOS.sdk_path_if_needed
      sdk/"usr/include" if sdk
    else
      HOMEBREW_PREFIX/"include"
    end

    includes = [include, sdk_include].compact.map do |inc|
      "'#{inc}',"
    end.join(" ")

    # We need to insert our include dir first
    inreplace "python/setup.py", "includes_dir = [",
                                 "includes_dir = [#{includes}"

    # Needed for Python 3.12+.
    # https://github.com/Homebrew/homebrew-core/pull/154551#issuecomment-1820102786
    with_env(PYTHONPATH: buildpath/"python") do
      pythons.each do |python|
        system python, "-m", "pip", "install", *std_pip_args, "./python"
      end
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libxml/tree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    C

    # Test build with xml2-config
    args = shell_output("#{bin}/xml2-config --cflags --libs").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Test build with pkg-config
    ENV.append "PKG_CONFIG_PATH", lib/"pkgconfig"
    args = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    pythons.each do |python|
      with_env(PYTHONPATH: prefix/Language::Python.site_packages(python)) do
        system python, "-c", "import libxml2"
      end
    end

    # Make sure cellar paths are not baked into these files.
    [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"].each do |file|
      refute_match HOMEBREW_CELLAR.to_s, file.read
    end
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index c6dc93d58f84f21c4528753d2ee1bc1d50e67ced..e7bad24d8f1aa7659e1aa4e2ad1986cc2167483b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -984,10 +984,10 @@ if test "$with_icu" != "no" && test "$with_icu" != "" ; then

     # Try pkg-config first so that static linking works.
     # If this succeeeds, we ignore the WITH_ICU directory.
-    PKG_CHECK_MODULES([ICU], [icu-i18n], [
-        WITH_ICU=1; XML_PC_REQUIRES="${XML_PC_REQUIRES} icu-i18n"
+    PKG_CHECK_MODULES([ICU], [icu-uc], [
+        WITH_ICU=1; XML_PC_REQUIRES="${XML_PC_REQUIRES} icu-uc"
         m4_ifdef([PKG_CHECK_VAR],
-            [PKG_CHECK_VAR([ICU_DEFS], [icu-i18n], [DEFS])])
+            [PKG_CHECK_VAR([ICU_DEFS], [icu-uc], [DEFS])])
         if test "x$ICU_DEFS" != "x"; then
             ICU_CFLAGS="$ICU_CFLAGS $ICU_DEFS"
         fi],[:])
