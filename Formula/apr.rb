class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.0.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.0.tar.bz2"
  sha256 "e2e148f0b2e99b8e5c6caa09f6d4fb4dd3e83f744aa72a952f94f5a14436f7ea"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "db4878de50f66ef4262bad2e7849563377d2e1e5258e80f6bbb77a734d4b6c09" => :big_sur
    sha256 "00e16fe5d213225b4d8d5905c5e5f8f0a1b774aedc4b2f02f4e88302dae11ac8" => :arm64_big_sur
    sha256 "a15b04b77fc4ad13322745c8b4f851ba09a60c3bff97bd025fe3299c8ff881e6" => :catalina
    sha256 "c36baed40f62b9cb9f3f9d93421db2fb90d6686846027c6379ff883ee39ccf00" => :mojave
  end

  keg_only :provided_by_macos, "Apple's CLT provides apr"

  depends_on "autoconf" => :build

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

  def install
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv

    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Needed to apply the patch.
    system "autoconf"

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    lib.install_symlink Dir["#{libexec}/lib/*.a"]
    lib.install_symlink Dir["#{libexec}/lib/#{shared_library("*")}"]
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    (include/"apr-#{version.major}").install_symlink Dir["#{libexec}/include/apr-#{version.major}/*.h"]

    rm Dir[libexec/"lib/*.la"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apr-#{version.major}-config", libexec, opt_libexec

    on_linux do
      # Avoid references to the Homebrew shims directory
      inreplace libexec/"build-#{version.major}/libtool", HOMEBREW_SHIMS_PATH/"linux/super/", "/usr/bin/"
    end
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apr-#{version.major}-config --prefix")
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
