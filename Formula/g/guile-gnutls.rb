class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://gitlab.com/gnutls/guile"
  url "https://gitlab.com/gnutls/guile/uploads/1fdc941351d54cd7affda1bb912b9ca5/guile-gnutls-3.7.14.tar.gz"
  sha256 "de2bfcd4fd93d669e85f83c48a53470390fed60987158e9a14c9ff8e0beeb651"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/gnutls/guile.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "5ebfa7a78bbfc3ce91e61c59c92e19f5374a9ce89be97dbaf6268ed7dbd57fd2"
    sha256 arm64_monterey: "bcee9c4f4fec9e77529fbfdfb5ebc34172e3f5fb843b52b5f1930ca107f3d22e"
    sha256 arm64_big_sur:  "4f1be19afcce8f67cf7c10681c64bbf35a05b09fe969f27c7ce2d4b8347266ca"
    sha256 ventura:        "117897d1ea309f33dfff4c94d7076d2f42ae7fd31274742c86045b68129c48d7"
    sha256 monterey:       "8e7841f41fe3e355253f70f16c8d6a3c81d59a1a532c474d8c73f7255ee311d1"
    sha256 big_sur:        "39556d329efc432990ec98f7a4f7616930011060705306150297364ba7a63875"
    sha256 x86_64_linux:   "7c2fe2e978904511e97e0a81263a584131df9dac8d84b097ae6c86ddb6ee8d9f"
  end

  depends_on "gnutls"
  depends_on "guile"

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] },
                          "--with-guile-site-dir=#{share}/guile/site/3.0",
                          "--with-guile-site-ccache-dir=#{lib}/guile/3.0/site-ccache",
                          "--with-guile-extension-dir=#{lib}/guile/3.0/extensions",
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
