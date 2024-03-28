class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20240323.tar.gz"
  sha256 "b6f397cf90fc18c925a7bcabcb75393c7cd2751ccd50efe93a4f401932513c45"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "d9559b6bd4107cab838ccf603066078763c6db17c489b2cad67aa52df94e2427"
    sha256 arm64_ventura:  "efb78a4858b6e9f8114a9e7b202cd95cfe2e1c7a198b6bbd154345dc1ad23902"
    sha256 arm64_monterey: "bc80c8063d23075980cfbc350f249f696d234976feefbce31cb03bb1e4086aa9"
    sha256 sonoma:         "f5dab7728fbf9cef34c3cae3901236b83baa54a14b856153b313dd5332e2139e"
    sha256 ventura:        "6297eb962571a3d2eea8e7037be71a89b3947091c33d4261ea4193f25be110f5"
    sha256 monterey:       "f68a4fb7972364c22004ec676730359841594c4500b98890079248f11d8d4c24"
    sha256 x86_64_linux:   "464b7d2777089a660f0bae6d6fd1212573a8658023f47cd98bc4c8352900e3fc"
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
