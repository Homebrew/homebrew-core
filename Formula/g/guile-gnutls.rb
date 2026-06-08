class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://codeberg.org/guile-gnutls/guile-gnutls"
  url "https://codeberg.org/guile-gnutls/guile-gnutls/releases/download/v5.0.1/guile-gnutls-5.0.1.tar.gz"
  sha256 "cc0067f3eeb421bc17247140962a49086df5450f0d3e71c55bf541a2d2b9ef2b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "975e9b65e6b30080b9bbac5a87afd83e2a5722c2b72920c90fb9122a2f45144c"
    sha256 arm64_sequoia: "95394cff621d1adab78963342fe6af29b5465190b0fbe67cc0df79f7219e735c"
    sha256 arm64_sonoma:  "1e31541c1f148acff0657dc55a994409d31c6d8be13fc16c2282775d70c5b727"
    sha256 sonoma:        "1046862293e93ae8a461b7a6dcaf2f823c4ec052ac4f24dd6ee8ac154196bce9"
    sha256 arm64_linux:   "1bb943a6cbc6f7aab143dfb69b26e0b17ac316f9e88614e1b833a525d134ccc4"
    sha256 x86_64_linux:  "e83b5913dec6fedd693056a6cc6a136b7036ffbc80ab83d21896c6a013244a1f"
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
