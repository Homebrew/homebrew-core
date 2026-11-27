class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.14.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.14.tar.xz"
  sha256 "7e2d258071f5db9620aa7ff34259331d004f7beafa3eb18560cfaf60acfbf02a"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]
  compatibility_version 2

  # The download page links to the directory listing pages for the "Next" and
  # "Current stable" versions. We use the "Next" version in the formula, so we
  # match versions from the tarball links on that directory listing page.
  livecheck do
    url "https://www.gnutls.org/download.html"
    regex(/href=.*?gnutls[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      # Find the higher version from the directory listing page URLs
      highest_version = page.scan(%r{href=.*?/gnutls/v?(\d+(?:\.\d+)+)/?["' >]}i)
                            .map { |match| match[0] }
                            .max_by { |v| Version.new(v) }
      next unless highest_version

      # Fetch the related directory listing page
      files_page = Homebrew::Livecheck::Strategy.page_content(
        "https://www.gnupg.org/ftp/gcrypt/gnutls/v#{highest_version}",
      )
      next if (files_page_content = files_page[:content]).blank?

      files_page_content.scan(regex).map { |match| match[0] }
    end
  end

  bottle do
    manifest_sha256 "a09a1795039eb09ca5d079166ef6651871354c9f1a57f4d4ab88e01ede8b5403"
    sha256 cellar: :any, arm64_golden_gate: "c118d53b47033725a76201d0f0c65bbbffa7176a5f54021c067c84381b194b50"
    sha256 cellar: :any, arm64_tahoe:       "5509d03e9fe545ff0848d3a5ee1c23a2e6ae077e6755cd0b04cca4b2d15b7872"
    sha256 cellar: :any, arm64_sequoia:     "0f91625c5ac8e6d4542de6eb8b484fa78074dc9b23c01afa7471cd08f2d9791f"
    sha256               arm64_linux:       "2eae01b3627aa62f7635ab50174c250e9a02796c26abc3bb92b7bc092809e7de"
    sha256               x86_64_linux:      "be82965b59fff42219ed399bbe6463aa0ef44e6bebc310599f7f1fc2118f1378"
  end

  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "ca-certificates" => :no_linkage
  depends_on "gmp"
  depends_on "libidn2"
  depends_on "libtasn1"
  depends_on "libunistring"
  depends_on "nettle"
  depends_on "p11-kit"

  on_macos do
    depends_on "gettext"
  end

  # Test performs a TLS handshake with expired.badssl.com
  allow_network_access! :test

  def install
    # DANE support is disabled so GnuTLS does not have an indirect dependency on OpenSSL.
    # If the feature is wanted, then can consider shipping as split `gnutls-dane` formula.
    args = %W[
      --disable-libdane
      --disable-silent-rules
      --disable-static
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{pkgetc}/cert.pem
      --disable-heartbeat-support
      --with-p11-kit
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    inreplace lib/"pkgconfig/gnutls.pc", prefix, opt_prefix

    # certtool shadows the macOS certtool utility
    mv bin/"certtool", bin/"gnutls-certtool"
    mv man1/"certtool.1", man1/"gnutls-certtool.1"
  end

  post_install_steps do
    symlink "{{etc}}/ca-certificates/cert.pem", "{{pkgetc}}/cert.pem", overwrite: true
  end

  def caveats
    "Guile bindings are now in the `guile-gnutls` formula."
  end

  test do
    system bin/"gnutls-cli", "--version"
    assert_match "expired certificate", shell_output("#{bin}/gnutls-cli expired.badssl.com", 1)
  end
end
