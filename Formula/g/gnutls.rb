class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.13.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.13.tar.xz"
  sha256 "ffed8ec1bf09c2426d4f14aae377de4753b53e537d685e604e99a8b16ca9c97e"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]
  revision 1
  compatibility_version 1

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
    sha256 cellar: :any, arm64_tahoe:   "6dbbabecf3b693ed30b1f153cf0f98bac12b3e0fa7fe785cde484cd36431d30f"
    sha256 cellar: :any, arm64_sequoia: "3dcb07236cdc2c242729ba8287b2b216816399006bc01fef1a0c6a8c689e20a5"
    sha256 cellar: :any, arm64_sonoma:  "4af91041ce4c658abbce2ac612788a7beb9042ade55cdc8011fa4989cf970e50"
    sha256 cellar: :any, sonoma:        "3d22af738ddc0843b1508ec6af958c96abddef594cf27bbf0f5f1e8d4a179165"
    sha256               arm64_linux:   "fe6844d8d7f8e1d42cc18b17fc84bf9a7e8eb72acdd5bc0b1821bebc69d6ea65"
    sha256               x86_64_linux:  "da55d168ee5b312eda15e29da3b40b6476a242cf94c8c5e003c5aa66d117f51b"
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
