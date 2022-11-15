class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.0.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.0.tar.bz2"
  sha256 "e2e148f0b2e99b8e5c6caa09f6d4fb4dd3e83f744aa72a952f94f5a14436f7ea"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e0a879c211c9c211262e55211187abb8c8c87f2ca14d6f41e144039312058e54"
    sha256 cellar: :any,                 arm64_monterey: "02e6b44b3284fa471cce15592a8666356f8d43b256bb08b391efbd521eddedd0"
    sha256 cellar: :any,                 arm64_big_sur:  "26736a76f4ad71f17a1a5068bbe0a1bfa2c48e26622d3ed959f3ce42165ddd0c"
    sha256 cellar: :any,                 ventura:        "3e01846ed6a8996e8bddb4c65fb352d185ead8ca56e42bb75b9be7640937c9e4"
    sha256 cellar: :any,                 monterey:       "365d71d8598761991d7c37831d11a4d355a5dc007863e5a677afd39d664d8351"
    sha256 cellar: :any,                 big_sur:        "e397174ca8509867732b3b39bd3620288d84504584320355c9b1d85df0350e9a"
    sha256 cellar: :any,                 catalina:       "ee9d9b6e5bb722c31ffac5ea0d2497f65feae2e69d73cafa44d63c99312d373d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9166ca46f30bc3f48b1087f107370800bb97ed74493cca5fc887b66ebc4c481b"
  end

  keg_only :provided_by_macos, "Apple's CLT provides apr"

  depends_on "autoconf@2.69" => :build

  uses_from_macos "libxcrypt"

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
