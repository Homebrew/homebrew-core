class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://codeberg.org/guile-gnutls/guile-gnutls"
  url "https://codeberg.org/guile-gnutls/guile-gnutls/releases/download/v5.0.2/guile-gnutls-5.0.2.tar.gz"
  sha256 "76ba2a0f47edde7fd2f583fc1162ed1ce8339bdaf7e9d9cc39387fcc95fb935b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "b313105e2382370a54d456742cd85f2a062ab9c39563826f6a325f77d56db83f"
    sha256 arm64_sequoia: "6509147f21e260e84f94d730b129121ff2a4f7922666b3a2436d8e757cce7729"
    sha256 arm64_sonoma:  "8ab04c813ed52b7671a1000733412cf4a7989559d92b98ea8ea346cea270db4d"
    sha256 sonoma:        "750f3b5de59464e339d042f3232e384cb6793f9ff44ab10281ec314cad331970"
    sha256 arm64_linux:   "8fbe51d775f07fcd3b4b192d593f3cf36e4435414fc695d7b7f5d72aa5516880"
    sha256 x86_64_linux:  "3aea5102f38be22db21e73e51673a1909946aaf0ecff29ba6a45055f62ee40aa"
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

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--with-guile-site-dir=#{share}/guile/site/3.0",
                          "--with-guile-site-ccache-dir=#{lib}/guile/3.0/site-ccache",
                          "--with-guile-extension-dir=#{lib}/guile/3.0/extensions",
                          "--disable-silent-rules",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  def post_install
    # Touch gnutls.go to avoid Guile recompilation.
    # See https://github.com/Homebrew/homebrew-core/pull/60307#discussion_r478917491
    touch lib/"guile/3.0/site-ccache/gnutls.go"
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
