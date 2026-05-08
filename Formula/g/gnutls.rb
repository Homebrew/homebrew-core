class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.13.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.13.tar.xz"
  sha256 "ffed8ec1bf09c2426d4f14aae377de4753b53e537d685e604e99a8b16ca9c97e"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]
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
    sha256 cellar: :any, arm64_tahoe:   "18db0c67bfa3137d02bf8f38a5cec216084c86a789bdaab5db9eba4964eb0c88"
    sha256 cellar: :any, arm64_sequoia: "8acaf18cb03a73800698ab4e056238c9cabf74e7efe74d288054eeacdedf8459"
    sha256 cellar: :any, arm64_sonoma:  "183ccacee048473aab71fe369f3fe8fb5362f2b063d609640d53b441bb6e7eb3"
    sha256 cellar: :any, sonoma:        "a5465977c52d8e166cf94f062a8a2195a050874f8cdbb7fb7d3e42df9fc92ed7"
    sha256               arm64_linux:   "213f90db6d02c8bf0a442f6fb121dea84e02d4cb25f9d3e4460472b325264960"
    sha256               x86_64_linux:  "6d205dae91a84de7f88ea13a2e055e6071cc06c9d9c1445c2528b0f968592121"
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
