class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.16.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.6/gnutls-3.6.16.tar.xz"
  sha256 "1b79b381ac283d8b054368b335c408fedcb9b7144e0c07f531e3537d4328f3b3"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]
  revision 1

  livecheck do
    url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/"
    regex(/href=.*?gnutls[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9c493190ccb3a9e805389c5b87003407a4bb808df54f307b830e66206987b9c4"
    sha256 arm64_big_sur:  "e1ec9389285dca7c52c0346cdd5112a2bfacfd31b1958d0267408573f1fb5ed0"
    sha256 monterey:       "c38aebba46bca205f64c7f3990938d39f563ca27fbcaff0b9cabcd6d8683a96d"
    sha256 big_sur:        "f165f3c8e4ecac781e269e08c39f8af457d1d634ee21f0d8edb2ca6d1808f03a"
    sha256 catalina:       "464f68e7e6f9c7698f921e3b8e23bd2302681041bb98c5f58c0be90833b4f48f"
    sha256 mojave:         "ea18603d9f6337b7e9a77bec91124102a7a4680ab8358f1ee8d17023223816ed"
    sha256 x86_64_linux:   "41e3d22d3117829ab83d8d06625732bda5bcc68b362f29318a777b4d884443cb"
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
