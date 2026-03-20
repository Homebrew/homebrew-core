class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.12.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.12.tar.xz"
  sha256 "a7b341421bfd459acf7a374ca4af3b9e06608dcd7bd792b2bf470bea012b8e51"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]

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
    sha256 arm64_tahoe:   "df6bfd97301eefdd39186a84e2089cd6b2ac62655a5bcf005e23c1b1e6631628"
    sha256 arm64_sequoia: "2c852d43e0792be1e1091677c8bd3021c69b6d4cd237ea35918c033893f9ab1b"
    sha256 arm64_sonoma:  "da087cf434671200e3c1b77f21341d9b5deb6e3df64b3868cc21212b965f9358"
    sha256 sonoma:        "6dd581133c9f496152ed69d45129f53408035392101cd9c44d64649d0fba8bfb"
    sha256 arm64_linux:   "ee21922877570b314f7457e9030fd915ca55ea6c0c343c8ccfce82b1f4914c5e"
    sha256 x86_64_linux:  "d99e673012799fbe5648e8f511230233f9280a6aaba82bb5e3fa4b257bc4d9e0"
  end

  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "ca-certificates"
  depends_on "gmp"
  depends_on "libidn2"
  depends_on "libtasn1"
  depends_on "libunistring"
  depends_on "nettle"
  depends_on "p11-kit"
  depends_on "unbound"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1400
    cause "error: CRAU_MAYBE_UNUSED is not getting defined"
  end

  def install
    args = %W[
      --disable-silent-rules
      --disable-static
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{pkgetc}/cert.pem
      --disable-heartbeat-support
      --with-p11-kit
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    inreplace [lib/"pkgconfig/gnutls.pc", lib/"pkgconfig/gnutls-dane.pc"], prefix, opt_prefix

    # certtool shadows the macOS certtool utility
    mv bin/"certtool", bin/"gnutls-certtool"
    mv man1/"certtool.1", man1/"gnutls-certtool.1"
  end

  def post_install
    rm(pkgetc/"cert.pem") if (pkgetc/"cert.pem").exist?
    pkgetc.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    "Guile bindings are now in the `guile-gnutls` formula."
  end

  test do
    system bin/"gnutls-cli", "--version"
    assert_match "expired certificate", shell_output("#{bin}/gnutls-cli expired.badssl.com", 1)
  end
end
