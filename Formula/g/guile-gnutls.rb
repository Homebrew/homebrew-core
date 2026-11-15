class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://codeberg.org/guile-gnutls/guile-gnutls"
  url "https://codeberg.org/guile-gnutls/guile-gnutls/releases/download/v5.0.3/guile-gnutls-5.0.3.tar.gz"
  sha256 "230ae4f89dffac6d57fff618410611820e1550907aeef6065b121fe6410a7b6b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_golden_gate: "93e16d2e9efc8b4c198fb1eab6ad25d9f8962aa2f8d517cbb70536c9aadf71e9"
    sha256 arm64_tahoe:       "075240290a35c9e2fdc8135fa2b964fd39f658ec6d224be1f6111376a4fd445c"
    sha256 arm64_sequoia:     "0c86c9616f89f8638906860034bb711503ef5e1cf232d1702284fd9e82d43d97"
    sha256 arm64_linux:       "79180d0624c48fd604650aabe1966c2982c7b4130b7eba74be13c761a3c075bd"
    sha256 x86_64_linux:      "65ca6d57bd4c84239cd50e9c57becf6ffd80cbd2b52c23552d71756ab8d8d7a8"
  end

  head do
    url "https://codeberg.org/guile-gnutls/guile-gnutls.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  depends_on "gnutls"
  depends_on "guile"

  on_macos do
    depends_on "bdw-gc"
  end

  deny_network_access!

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--with-guile-site-dir=#{share}/guile/site/3.0",
                          "--with-guile-site-ccache-dir=#{lib}/guile/3.0/site-ccache",
                          "--with-guile-extension-dir=#{lib}/guile/3.0/extensions",
                          "--disable-silent-rules",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  post_install_steps do
    # Touch gnutls.go to avoid Guile recompilation.
    # See https://github.com/Homebrew/homebrew-core/pull/60307#discussion_r478917491
    touch "{{lib}}/guile/3.0/site-ccache/gnutls.go"
  end

  def caveats
    <<~EOS
      If you are going to use the Guile bindings you will need to add the following
      to your .bashrc or equivalent in order for Guile to find the TLS certificates
      database:
        export GUILE_TLS_CERTIFICATE_DIRECTORY=#{Formula["gnutls"].pkgetc}/
    EOS
  end

  test do
    gnutls = testpath/"gnutls.scm"
    gnutls.write <<~SCHEME
      (use-modules (gnutls))
      (gnutls-version)
    SCHEME

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", gnutls
  end
end
