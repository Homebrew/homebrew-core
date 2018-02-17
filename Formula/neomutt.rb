class Neomutt < Formula
  desc "Teaching an Old Dog New Tricks"
  homepage "https://www.neomutt.org/"
  url "https://github.com/neomutt/neomutt.git", :tag => "neomutt-20171215", :revision => "ae61285170533b4be544e738cdd2eedefd1856ff"
  head "https://github.com/neomutt/neomutt.git", :branch => "master"

  option "with-lmdb", "Build with lmdb support"
  option "with-lua", "Build with lua scripting support enabled"
  option "with-s-lang", "Build against slang instead of ncurses"

  # Neomutt-specific patches
  option "with-notmuch-patch", "Apply notmuch patch"

  depends_on "gettext" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libxslt" => :build unless OS.mac?
  depends_on "krb5" => :build unless OS.mac?

  depends_on "openssl"
  depends_on "tokyo-cabinet" => :recommended unless build.with?("lmdb")
  depends_on "lmdb" => :optional
  depends_on "gpgme" => :optional
  depends_on "libidn" => :optional
  depends_on "lua" => :optional
  depends_on "s-lang" => :optional
  depends_on "notmuch" if build.with? "notmuch-patch"

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --prefix=#{prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --gss
      --disable-idn
    ]

    args << "--enable-gpgme" if build.with? "gpgme"

    # Neomutt-specific patches
    args << "--notmuch" if build.with? "notmuch-patch"

    args << "--sasl" unless OS.linux?

    if build.with? "lmdb"
      args << "--lmdb"
    else
      args << "--tokyocabinet"
    end

    if build.with? "lua"
      args << "--lua"
      args << "--with-lua=#{Formula["lua"].prefix}"
    end

    if build.with? "s-lang"
      args << "--with-ui=slang"
    else
      args << "--with-ui=ncurses"
    end

    system "./configure", *args
    system "make"

    system "make", "install"
  end

  test do
    system bin/"neomutt", "-D"
  end
end
