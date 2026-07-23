class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://codeberg.org/guile-gnutls/guile-gnutls"
  url "https://codeberg.org/guile-gnutls/guile-gnutls/releases/download/v5.0.2/guile-gnutls-5.0.2.tar.gz"
  sha256 "76ba2a0f47edde7fd2f583fc1162ed1ce8339bdaf7e9d9cc39387fcc95fb935b"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7a7e4c3927ac3a3a4abf9e783fdbba42efff0156a425c937248a921d461e8bd1"
    sha256 arm64_sequoia: "4f999b97f86f3b891da3dd638432cd1766567be29ec965c95f2089e765831945"
    sha256 arm64_sonoma:  "570d2b025ebc591415057e176ac9b19040f80b7e1f4a303e7f22cc06f2dd8846"
    sha256 sonoma:        "1b0efc78f64687a8bc1202d9f25a1314ddc869fea2f32e8747a5a745b7e766a3"
    sha256 arm64_linux:   "058ac4f670b9b0813119aed187b93e9d42f009b611879255e8be53a66b8c3d5b"
    sha256 x86_64_linux:  "ad881df0017917a8e39d7ba4f8ce29e215b13700dd87ec8775ff43736256e9b9"
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

  post_install_steps do
    # Touch gnutls.go to avoid Guile recompilation.
    # See https://github.com/Homebrew/homebrew-core/pull/60307#discussion_r478917491
    touch "guile/3.0/site-ccache/gnutls.go", base: :lib
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
