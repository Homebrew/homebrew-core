class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.9.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.9.tar.xz"
  sha256 "69e113d802d1670c4d5ac1b99040b1f2d5c7c05daec5003813c049b5184820ed"
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
    sha256 arm64_sequoia: "eaf32401a72c80651227e7f5ab70ff762fe7bd990bb566bf4621b37e570ddc66"
    sha256 arm64_sonoma:  "2d163de276e87a18604036beb10346fd37bdbeb4ff5fea25137c4680af19ce90"
    sha256 arm64_ventura: "449610f6f2c79b039cf3f1ea411aad84e97f72e251bebe8c62fdbf577ecc8509"
    sha256 sonoma:        "2eb812e6c094f544e61d0d50b200138ba2a6f56cacd111a2c40fc248a62b6193"
    sha256 ventura:       "580ac871323833e54492cb4fa2b1f5629db8dddf80a177112df5db39a1e2e904"
    sha256 arm64_linux:   "9b3b3dc001ebd678f2fd3e82b85de6b52b371f3a567231f59765dcada04afcd6"
    sha256 x86_64_linux:  "b0c2c48ea42aa6768c7b6bb6ff2fba60f6e334817dc27beac7f06686b1fe3254"
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
