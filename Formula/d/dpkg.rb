class Dpkg < Formula
  desc "Debian package management system"
  homepage "https://wiki.debian.org/Teams/Dpkg"
  # Please use a mirror as the primary URL as the
  # dpkg site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://deb.debian.org/debian/pool/main/d/dpkg/dpkg_1.23.7.tar.xz"
  sha256 "60fe2be72e5f0a4bb0ac7baff3b1697ebc5cfaac1885f66649521571a97440ad"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/dpkg/"
    regex(/href=.*?dpkg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "119444a13bf9104f7c894e711634e74c1350b998ecd97e74d3d7b57d74bf3bb4"
    sha256 arm64_sequoia: "6bb9bc20f0df7d28acd926afebb3c2c2993b5b33777c23a0bc05f3aee91adc20"
    sha256 arm64_sonoma:  "2ac0841e52075bfb1ef8b08fe3ded6a733df307afec11f079e55fb31f86f7c38"
    sha256 sonoma:        "895d9265c24b7011e3ed1f31ba8450b01a2310b41e3257d02bd871f7e290e151"
    sha256 arm64_linux:   "ba5ae6349e29398b69e90746b5efd8ce4c2beeea84a6e44ecd7f5db07be2771f"
    sha256 x86_64_linux:  "e20026502a0053e8e3284745c5d3263d6ab157fd16fdb5104bc78e7f5f02139e"
  end

  depends_on "pkgconf" => :build
  depends_on "po4a" => :build
  depends_on "gettext"
  depends_on "gnu-tar"
  depends_on "gpatch"
  depends_on "libmd" # for md5.h
  depends_on "perl" # perl >= 5.36.0
  depends_on "xz" # For LZMA

  uses_from_macos "bzip2"

  on_linux do
    keg_only "it conflicts with system dpkg"

    depends_on "zlib-ng-compat"
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
    ENV["PATCH"] = if OS.mac?
      Formula["gpatch"].opt_bin/"gpatch"
    else
      Formula["gpatch"].opt_bin/"patch"
    end

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
