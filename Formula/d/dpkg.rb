class Dpkg < Formula
  desc "Debian package management system"
  homepage "https://wiki.debian.org/Teams/Dpkg"
  # Please use a mirror as the primary URL as the
  # dpkg site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://deb.debian.org/debian/pool/main/d/dpkg/dpkg_1.23.12.tar.xz"
  sha256 "829e7a454f61232b33372c1564b803ab16cfc98e08bd2ec1e2b94bdb1fb97502"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/dpkg/"
    regex(/href=.*?dpkg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "006104df9008756d2ef443fa5e61932716995233e6a1d04d26afaafe9c48638d"
    sha256 arm64_tahoe:       "a499509fd23f412c6fb65a00f44296207d98a1d435133a98c4878b484be9ccc3"
    sha256 arm64_sequoia:     "08c34d640bb28d6aea83438a13ca50e31d03e62bfc567edfb77218a9ec6c6d93"
    sha256 arm64_linux:       "735939b62c5d5b9e10fa8339f73c6377d6d58535f0fdf3c9949d66f50da6a626"
    sha256 x86_64_linux:      "8f4ce201df665c2409c9c2bdb27fdf5d21dda7b4f0f650481765539aa667aba7"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "po4a" => :build
  depends_on "gnu-tar"
  depends_on "gpatch"
  depends_on "libmd" # for md5.h
  depends_on "perl" # perl >= 5.36.0
  depends_on "xz" # For LZMA

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    keg_only "it conflicts with system dpkg"

    depends_on "zlib-ng-compat"
    depends_on "zstd"
  end

  patch :DATA

  deny_network_access!

  def install
    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system "tar", which will fail because it lacks certain switches.
    ENV["TAR"] = formula_opt_bin("gnu-tar")/(OS.mac? ? "gtar" : "tar")

    # Since 1.18.24 dpkg mandates the use of GNU patch to prevent occurrences
    # of the CVE-2017-8283 vulnerability.
    # https://www.openwall.com/lists/oss-security/2017/04/20/2
    ENV["PATCH"] = formula_opt_bin("gpatch")/(OS.mac? ? "gpatch" : "patch")

    # Theoretically, we could reinsert a patch here submitted upstream previously
    # but the check for PERL_LIB remains in place and incompatible with Homebrew.
    # Using an env and scripting is a solution less likely to break over time.
    # Both variables need to be set. One is compile-time, the other run-time.
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    system "./configure", "--disable-dselect",
                          "--disable-silent-rules",
                          "--disable-start-stop-daemon",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args(prefix: libexec)
    system "make"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    man.install Dir[libexec/"share/man/*"]
    (lib/"pkgconfig").install_symlink Dir[libexec/"lib/pkgconfig/*.pc"]
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])

    (buildpath/"dummy").write "Vendor: dummy\n"
    (pkgetc/"origins").install "dummy"
    (pkgetc/"origins").install_symlink "dummy" => "default"
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
    assert_path_exists testpath/"test.deb"

    rm_r("test")
    system bin/"dpkg", "-x", "test.deb", testpath
    assert_path_exists testpath/"data/homebrew.txt"
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
