class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20240416.tar.gz"
  sha256 "d1b90308bf1fa4771f4ceb2c11e738620f6b18186149a24e006b5680ef3c64b6"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "ce633c401757f8192baaab8ed6b6f0b00a0b2248c11db9f0c4a17c837ca49ecf"
    sha256 arm64_ventura:  "46819bff564178bed9746ac2e8def1b137425e241848f68ef1e294c78d7d4bd0"
    sha256 arm64_monterey: "2f37740ff96c2efd0cf6cb9847c62dd99555a5541c85153d1f28a02888037fa6"
    sha256 sonoma:         "1c0fb09faab3d866cf80f5efd0083f871feba92d233eab8c80cb7825ea2c5a7e"
    sha256 ventura:        "55487befbc058caa3ff61d77a660a26ed27ffd7527676997d22928cc020454ee"
    sha256 monterey:       "4e39e897d6ce3b6d03e84c616b8636aada282fd0d23f8e4a211673eb6ee0f3d0"
    sha256 x86_64_linux:   "6b7f8d6e8719aa9c3c165cfc6495057d9a64e6ba5e84ea78fd419f9997904bc8"
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  # The build breaks when it tries to use system `tclsh`.
  depends_on "tcl-tk" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    # Build again libiconv for now on,
    # but reconsider when macOS 14.2 is released
    depends_on "libiconv"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --sysconfdir=#{etc}
      --autocrypt
      --gss
      --disable-idn
      --idn2
      --lmdb
      --nls
      --notmuch
      --pcre2
      --sasl
      --sqlite
      --tokyocabinet
      --zlib
      --with-idn2=#{Formula["libidn2"].opt_prefix}
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ncurses=#{Formula["ncurses"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
    ]

    args << "--with-iconv=#{Formula["libiconv"].opt_prefix}" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
