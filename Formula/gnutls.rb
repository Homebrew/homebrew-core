class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.4.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.7/gnutls-3.7.4.tar.xz"
  sha256 "e6adbebcfbc95867de01060d93c789938cf89cc1d1f6ef9ef661890f6217451f"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]

  livecheck do
    url "https://www.gnutls.org/news.html"
    regex(/>\s*GnuTLS\s*v?(\d+(?:\.\d+)+)\s*</i)
  end

  bottle do
    sha256 arm64_monterey: "64e98c4d7ae8140c87befc258efde25b817e0d02e9be019f848482eae080ed28"
    sha256 arm64_big_sur:  "93285dd80febcd6b529599bff7c786d0671d0a68389830e132904064608a8805"
    sha256 monterey:       "d366872e56d37603bead5b8453d2885ec521a912c58cfd4ccc9b319f249e29a0"
    sha256 big_sur:        "8b12ccd273f63bde6a405d1c10e053612e08681a4eeac07f8a6a677c2669ddc6"
    sha256 catalina:       "e4bd55f4284eda05c7ad59946a094d254cccf15d9f751989c218f2841b55da52"
    sha256 x86_64_linux:   "0a65c9293bce963a2f98197319d08e18471ec97baa389d6f475ac36ae4fc3880"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "gmp"
  depends_on "guile"
  depends_on "libidn2"
  depends_on "libtasn1"
  depends_on "libunistring"
  depends_on "nettle"
  depends_on "p11-kit"
  depends_on "unbound"

  on_linux do
    depends_on "autogen"
  end

  def install
    # Fix build with Xcode 12
    # https://gitlab.com/gnutls/gnutls/-/issues/1116
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{pkgetc}/cert.pem
      --with-guile-site-dir=#{share}/guile/site/3.0
      --with-guile-site-ccache-dir=#{lib}/guile/3.0/site-ccache
      --with-guile-extension-dir=#{lib}/guile/3.0/extensions
      --disable-heartbeat-support
      --with-p11-kit
    ]

    system "./configure", *args
    # Adding LDFLAGS= to allow the build on Catalina 10.15.4
    # See https://gitlab.com/gnutls/gnutls/-/issues/966
    system "make", "LDFLAGS=", "install"

    # certtool shadows the macOS certtool utility
    mv bin/"certtool", bin/"gnutls-certtool"
    mv man1/"certtool.1", man1/"gnutls-certtool.1"
  end

  def post_install
    rm_f pkgetc/"cert.pem"
    pkgetc.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"

    # Touch gnutls.go to avoid Guile recompilation.
    # See https://github.com/Homebrew/homebrew-core/pull/60307#discussion_r478917491
    touch lib/"guile/3.0/site-ccache/gnutls.go"
  end

  def caveats
    <<~EOS
      If you are going to use the Guile bindings you will need to add the following
      to your .bashrc or equivalent in order for Guile to find the TLS certificates
      database:
        export GUILE_TLS_CERTIFICATE_DIRECTORY=#{pkgetc}/
    EOS
  end

  test do
    system bin/"gnutls-cli", "--version"

    gnutls = testpath/"gnutls.scm"
    gnutls.write <<~EOS
      (use-modules (gnutls))
      (gnutls-version)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", gnutls
  end
end
