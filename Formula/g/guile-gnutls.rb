class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://gitlab.com/gnutls/guile"
  url "https://gitlab.com/gnutls/guile/uploads/9060bc55069cedb40ab46cea49b439c0/guile-gnutls-4.0.0.tar.gz"
  sha256 "5b4cb926032076ec346bb5c0bc0d0231f968fe0f565913cc16934bb793afb239"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/gnutls/guile.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "01a683c88e2e7f41743b06a5324571c3c9b76a26d5f38cd2085fac6c24b2f66e"
    sha256 arm64_sonoma:   "fa04d75c5e4ce832178da0dd59c0903976517ec88bab6e447c2635f8efabcf86"
    sha256 arm64_ventura:  "904211d84327edf97c2f981c332cfa4b87f9ae6acead1bd3fb03dbf730f86eb7"
    sha256 arm64_monterey: "4a838b2cf2c2dd0e6709cd43201a9c8dc5cc7e09705a00eb2523cb9785048c07"
    sha256 arm64_big_sur:  "ba2ef38bd8e6930920cbc9541d52e1d661858dd6f1a678018f3352b9affb6da5"
    sha256 sonoma:         "60ec990b57c525b59f4dc15a197c55efabf364be72a569db4e5231a60c6b8a00"
    sha256 ventura:        "ce529583a5a68f8ee4369922bf37ed729a4a7889347047f41221c654b95fc040"
    sha256 monterey:       "13b7f3129d9b70f721db8e2a111c8e013e981076aef2d80628c83464a7c5b5f8"
    sha256 big_sur:        "a9a905b1b7d1a8c74558474e5f75a3b267688221b598babdee1601e72f72d0f6"
    sha256 x86_64_linux:   "4ac661ae9b1570dac4da9e15ded15e72c88be83d44d7b6f11a74b9773e1b5993"
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
