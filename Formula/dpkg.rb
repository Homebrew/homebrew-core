class Dpkg < Formula
  desc "Debian package management system"
  homepage "https://wiki.debian.org/Teams/Dpkg"
  # Please use a mirror as the primary URL as the
  # dpkg site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://deb.debian.org/debian/pool/main/d/dpkg/dpkg_1.21.18.tar.xz"
  sha256 "7fcbbf28ecf622bad84229114dab4f62e0b0c29f6263b00dd1f3f73fe40e1062"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/dpkg/"
    regex(/href=.*?dpkg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5c577ed9e78189c87d8b3a9c2f93d235dca2ec08794d88366bd6d194ea912db3"
    sha256 arm64_monterey: "8b2b1b9c97d86064cb66d992fad62a68068fc81d6db5e80fdce6d89ab1413f29"
    sha256 arm64_big_sur:  "672b1404d61d46355159ccf909f9a78e123e370573e329366693af15a775fb7f"
    sha256 ventura:        "4f4ccbc7e1d8fe4e8eed8a04353620fab8cb9a659e32418be5905cba92674462"
    sha256 monterey:       "a1401fb70fe8289b3da7b67bce69318459c4d569c311f3a353f158def76df50e"
    sha256 big_sur:        "e284d7abe06525ab5f1a4695ac160e601424c0a8fe7f1ca03b4e84a06cf5b00c"
    sha256 x86_64_linux:   "862ec4f5c06ae7b1dff8d1b21f39d66ad50b4d44ff9d44268a75fdbc9d33a677"
  end

  depends_on "pkg-config" => :build
  depends_on "po4a" => :build
  depends_on "gettext"
  depends_on "gnu-tar"
  depends_on "gpatch"
  depends_on "libmd" # for md5.h
  depends_on "perl"
  depends_on "xz" # For LZMA

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    keg_only "not linked to prevent conflicts with system dpkg"
  end

  patch :DATA

  def install
    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system "tar", which will fail because it lacks certain switches.
    ENV["TAR"] = if OS.mac?
      Formula["gnu-tar"].opt_bin/"gtar"
    else
      Formula["gnu-tar"].opt_bin/"tar"
    end

    # Since 1.18.24 dpkg mandates the use of GNU patch to prevent occurrences
    # of the CVE-2017-8283 vulnerability.
    # https://www.openwall.com/lists/oss-security/2017/04/20/2
    ENV["PATCH"] = Formula["gpatch"].opt_bin/"patch"

    # Theoretically, we could reinsert a patch here submitted upstream previously
    # but the check for PERL_LIB remains in place and incompatible with Homebrew.
    # Using an env and scripting is a solution less likely to break over time.
    # Both variables need to be set. One is compile-time, the other run-time.
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dselect",
                          "--disable-start-stop-daemon"
    system "make"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    man.install Dir[libexec/"share/man/*"]
    (lib/"pkgconfig").install_symlink Dir[libexec/"lib/pkgconfig/*.pc"]
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])

    (buildpath/"dummy").write "Vendor: dummy\n"
    (etc/"dpkg/origins").install "dummy"
    (etc/"dpkg/origins").install_symlink "dummy" => "default"
  end

  def post_install
    (var/"lib/dpkg").mkpath
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      This installation of dpkg is not configured to install software, so
      commands such as `dpkg -i`, `dpkg --configure` will fail.
    EOS
  end

  test do
    # Do not remove the empty line from the end of the control file
    # All deb control files MUST end with an empty line
    (testpath/"test/data/homebrew.txt").write "brew"
    (testpath/"test/DEBIAN/control").write <<~EOS
      Package: test
      Version: 1.40.99
      Architecture: amd64
      Description: I am a test
      Maintainer: Dpkg Developers <test@test.org>

    EOS
    system bin/"dpkg", "-b", testpath/"test", "test.deb"
    assert_predicate testpath/"test.deb", :exist?

    rm_rf "test"
    system bin/"dpkg", "-x", "test.deb", testpath
    assert_predicate testpath/"data/homebrew.txt", :exist?
  end
end

__END__
diff --git a/lib/dpkg/i18n.c b/lib/dpkg/i18n.c
index 4952700..81533ff 100644
--- a/lib/dpkg/i18n.c
+++ b/lib/dpkg/i18n.c
@@ -23,6 +23,11 @@

 #include <dpkg/i18n.h>

+#ifdef __APPLE__
+#include <string.h>
+#include <xlocale.h>
+#endif
+
 #ifdef HAVE_USELOCALE
 static locale_t dpkg_C_locale;
 #endif
