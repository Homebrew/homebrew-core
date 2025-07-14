class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.10.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.10.tar.xz"
  sha256 "db7fab7cce791e7727ebbef2334301c821d79a550ec55c9ef096b610b03eb6b7"
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
    sha256 arm64_sequoia: "62b817f56075b97caddec5777728d0851de6d126a12458914e4a90f6f79a1312"
    sha256 arm64_sonoma:  "d43ad0fa7a031d4448e9069b7292ab06c31b80fb87ce399b7a93e4e6e045b2c4"
    sha256 arm64_ventura: "27dd9084ba8330e173ffd31d42d1dbb8df358c5f624a6b0cc4cccf077515d2a3"
    sha256 sonoma:        "c51042eeda15d908411b453fa586237f046c2f4fb7f4083b43f454df95440291"
    sha256 ventura:       "3391918b37750fc4b77247355c1caad1d1e67adcf0879301d70c4949b42eb4d1"
    sha256 arm64_linux:   "23512f82143b660e68c0c00bd70e37a9dfc35a43d293492dd687b3f4a8194633"
    sha256 x86_64_linux:  "6dc643f51d58c12c025c77234c6498b944c30bcd1bd22134df11fa4f6ac2dade"
  end

  depends_on "pkgconf" => :build

  depends_on "ca-certificates"
  depends_on "gmp"
  depends_on "libidn2"
  depends_on "libtasn1"
  depends_on "libunistring"
  depends_on "nettle"
  depends_on "p11-kit"
  depends_on "unbound"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
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

    # certtool shadows the macOS certtool utility
    mv bin/"certtool", bin/"gnutls-certtool"
    mv man1/"certtool.1", man1/"gnutls-certtool.1"
  end

  def post_install
    rm(pkgetc/"cert.pem") if (pkgetc/"cert.pem").exist?
    pkgetc.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      Guile bindings are now in the `guile-gnutls` formula.
    EOS
  end

  test do
    system bin/"gnutls-cli", "--version"
    assert_match "expired certificate", shell_output("#{bin}/gnutls-cli expired.badssl.com", 1)
  end
end
