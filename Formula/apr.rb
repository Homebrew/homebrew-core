class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.0.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.0.tar.bz2"
  sha256 "e2e148f0b2e99b8e5c6caa09f6d4fb4dd3e83f744aa72a952f94f5a14436f7ea"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ecc2c4b61e538c3a39fe228221356c2aae9c3d967f72e20a7978206321ef15b4"
    sha256 cellar: :any,                 arm64_big_sur:  "d8adb33071a6a845ff928b6166377dea6de5b642b412042002386416354932b9"
    sha256 cellar: :any,                 monterey:       "706df15280f05bc3ab057bd5dd856746f02c4fcc7356cccd5babd92a6362f132"
    sha256 cellar: :any,                 big_sur:        "d9a9554a726ec60e124055a55747e6e7f4cff6310955d6340be340ac053ac097"
    sha256 cellar: :any,                 catalina:       "3f5c1fa8f17715291ce9f66cf4eb4f518ac1aa856c485f0157036459ad63792c"
    sha256 cellar: :any,                 mojave:         "4627416a5d9c651d2d4fbb7faa639d6f7a89c7c0558576eeac1f17a81a17f3bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc3b583e8e0773016a5749e947939f895043a1155968fdbab795d3fba9fe801c"
  end

  keg_only :provided_by_macos, "Apple's CLT provides apr"

  depends_on "autoconf@2.69" => :build

  on_linux do
    depends_on "util-linux"
  end

  # Apply r1871981 which fixes a compile error on macOS 11.0.
  # Remove with the next release, along with the autoconf call & dependency.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7e2246542543bbd3111a4ec29f801e6e4d538f88/apr/r1871981-macos11.patch"
    sha256 "8754b8089d0eb53a7c4fd435c9a9300560b675a8ff2c32315a5e9303408447fe"
  end

  # Apply r1882980+1882981 to fix implicit exit() declaration
  # Remove with the next release, along with the autoconf call & dependency.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fa29e2e398c638ece1a72e7a4764de108bd09617/apr/r1882980%2B1882981-configure.patch"
    sha256 "24189d95ab1e9523d481694859b277c60ca29bfec1300508011794a78dfed127"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  # We patch `libtool.m4` directly because we call `autoconf`.
  patch :DATA

  def install
    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Needed to apply the patch.
    system "autoconf"

    system "./configure", *std_configure_args
    system "make", "install"

    # Install symlinks so that linkage doesn't break for reverse dependencies.
    # Remove at version/revision bump from version 1.7.0 revision 2.
    (libexec/"lib").install_symlink lib.glob(shared_library("*"))

    rm lib.glob("*.{la,exp}")

    # No need for this to point to the versioned path.
    inreplace bin/"apr-#{version.major}-config", prefix, opt_prefix

    # Avoid references to the Homebrew shims directory
    inreplace prefix/"build-#{version.major}/libtool", Superenv.shims_path, "/usr/bin" if OS.linux?
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apr-#{version.major}-config --prefix")
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <apr-#{version.major}/apr_version.h>
      int main() {
        printf("%s", apr_version_string());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lapr-#{version.major}", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end

__END__
diff --git a/build/libtool.m4 b/build/libtool.m4
index e86a682..c1c342f 100644
--- a/build/libtool.m4
+++ b/build/libtool.m4
@@ -1067,16 +1067,11 @@ _LT_EOF
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[[91]]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[[012]][[,.]]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[[012]],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
