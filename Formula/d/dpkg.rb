class Dpkg < Formula
  desc "Debian package management system"
  homepage "https://wiki.debian.org/Teams/Dpkg"
  # Please use a mirror as the primary URL as the
  # dpkg site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://deb.debian.org/debian/pool/main/d/dpkg/dpkg_1.22.17.tar.xz"
  sha256 "3fed39c5d04102f4cee8ed20b25462fcadae392cb8fe7dac518d6deaad379618"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/dpkg/"
    regex(/href=.*?dpkg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "09843937921d775fb5736fc85deca6ccc3d6f1da971c32e50ad296bd07af004d"
    sha256 arm64_sonoma:  "b630907f76a94c3f6ed4fd357b255ea5cd77a07ddc0c935f24f5e95b2ad45132"
    sha256 arm64_ventura: "2ceac14f7a993bdfc68143a9d67cfa9bdc7b9c6b7ee01df4462d9217e70856ad"
    sha256 sonoma:        "d9cde790b8aa10b7a22c182da58c59a86596fc50b2dc784c01a3b58c4e5994b7"
    sha256 ventura:       "f75f43cb0573336215c9bef6413d9bab53e44c1621fbdd95ce2025006a50b8b1"
    sha256 x86_64_linux:  "4e380870e47331d8f0392c2df14402b3819e2432953989b5eefdfea02ce31bd3"
  end

  depends_on "pkgconf" => :build
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
