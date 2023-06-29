class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://gitlab.com/gnutls/guile"
  url "https://gitlab.com/gnutls/guile/uploads/3fe12c208bdc6155c5116cf5eac7a2ad/guile-gnutls-3.7.12.tar.gz"
  sha256 "5d3af11573093de59f258415872e2c5b14cca9dd251a8b2ec1643d6e97fee336"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/gnutls/guile.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "76be86539dd101e571939d85f367753cf5b9feffd8715ddbacfa143d94111765"
    sha256 arm64_monterey: "ccfbe1ae554ba7f66c516136a9e20a913508bb8682dc168aee2715c55fb5bd8f"
    sha256 arm64_big_sur:  "e1cbf1d1781e4c7943850015a31ea4ef3d68575c1752bf9ebffb112f1e92d470"
    sha256 ventura:        "e500ac41113618a01c642a717636d67caa91886dc5d7c9b55309a883c2a7d626"
    sha256 monterey:       "e7cf8cb70219f51bd3842c7c5d8e16e4167c087427eb2cc6932906b697508078"
    sha256 big_sur:        "f3223f2e41070c82d040edf761da2efb2bff7a92e6c6b2b00fd3d3c8f93e917a"
    sha256 x86_64_linux:   "67d4876372fd6c76eed08ebce6df6dac0f571b586e1d07b091f64d34ad575b37"
  end

  depends_on "gnutls"
  depends_on "guile"

  def install
    # configure: WARNING: unrecognized options: --disable-debug
    system "./configure", "--prefix=#{prefix}",
                          "--with-guile-site-dir=#{share}/guile/site/3.0",
                          "--with-guile-site-ccache-dir=#{lib}/guile/3.0/site-ccache",
                          "--with-guile-extension-dir=#{lib}/guile/3.0/extensions",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
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
