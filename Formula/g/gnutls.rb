class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.13.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.13.tar.xz"
  sha256 "ffed8ec1bf09c2426d4f14aae377de4753b53e537d685e604e99a8b16ca9c97e"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]
  revision 2
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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "a2334eb50a165945aad7df804a3e846053de62973f6aee8060fec8c16c59446b"
    sha256 cellar: :any, arm64_sequoia: "0c8ba0cb42636a98b28a2c173b33c4298a286972a9838d27602f0bbc860acdbb"
    sha256 cellar: :any, arm64_sonoma:  "3e7fd6bf0a203f1b700c3c7e73d3a99b06c678eeb5335341339659ab5f00655c"
    sha256 cellar: :any, sonoma:        "77ec479ca9c1a6c80058f5bc9a908a1afd271f39a5cf69935e07fea4129a3824"
    sha256               arm64_linux:   "1f5ee025df39e40fb4197fdb0ab82f4f657a70972554e8296af6b910d80f9e47"
    sha256               x86_64_linux:  "8ac010d174af7ca336b9113fa208aa05104eb6b60e4e42f86c4212ad77ff6ad2"
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

  # Backport support for building with older clang
  patch do
    url "https://gitlab.com/gnutls/gnutls/-/commit/29c2027c963cf559817d0da37c1fc2efd0c1bd6a.diff"
    sha256 "c0bfc0164ff131c9d2e1c4d0367430f8b767b64c9c21e0f408bd634d21fb0302"
  end

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
    symlink "cert.pem", "cert.pem",
          source_formula: "ca-certificates",
          source_base:    :formula_pkgetc,
          target_base:    :pkgetc, overwrite: true
  end

  def caveats
    "Guile bindings are now in the `guile-gnutls` formula."
  end

  test do
    system bin/"gnutls-cli", "--version"
    assert_match "expired certificate", shell_output("#{bin}/gnutls-cli expired.badssl.com", 1)
  end
end
