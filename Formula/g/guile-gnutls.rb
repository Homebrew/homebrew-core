class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://gitlab.com/gnutls/guile"
  url "https://gitlab.com/-/project/40217954/uploads/f80b3a30cfc66c988775edc4ce3fb546/guile-gnutls-4.0.1.tar.gz"
  sha256 "01f0ba3bea837bb44dcb1b3ffcce3c2ebe88699d0a3bddac1d879e475a9787e4"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/gnutls/guile.git", branch: "master"

  livecheck do
    url "https://gitlab.com/api/v4/projects/40217954/releases"
    regex(/^(?:gnutls[._-])?v?(\d+(?:[._]\d+)+)$/i)
    strategy :json do |json, regex|
      json.map { |item| item["tag_name"]&.[](regex, 1)&.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "6bb5b450af554f8e7a4d620732e6bd6d5579be051adc9171f9b43b1e3ef7da9d"
    sha256 arm64_sequoia: "774fbd9464a92152b3506f67c9e5b2f7349575e2031293e50132017b7a3e98bb"
    sha256 arm64_sonoma:  "a50a21859c4523e1a26aa0e9b566d69b8351da2a31b8f01999b407551b2cc4d1"
    sha256 arm64_ventura: "54ab78a024a433b7617ce26f88fac53debc42320651d7d6729a6c52c044d2071"
    sha256 sonoma:        "5809a5ecdd6bacd5cb63f20aa5fd4d8af796e3d63c1554851090699d496f96a6"
    sha256 ventura:       "2cf7fdb17f501d3585ec6025132bc4b598349043e4d12ee82fec511fd7864b0d"
    sha256 arm64_linux:   "88ed2db04fcd5075579b4aa0176f0d89b8e39d9aff7e6ea8770f4aeb7ccd78bd"
    sha256 x86_64_linux:  "6d35dcf9c11c5b00943128d0a9a4ad7e2fc97b470a34879729f77412ac6af431"
  end

  depends_on "gnutls"
  depends_on "guile"

  on_macos do
    depends_on "bdw-gc"
  end

  def install
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
