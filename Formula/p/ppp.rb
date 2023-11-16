class Ppp < Formula
  desc "Provides a standard way to establish a network connection over a serial link"
  homepage "https://github.com/ppp-project/ppp"
  url "https://github.com/ppp-project/ppp/archive/refs/tags/ppp-2.5.0.tar.gz"
  sha256 "425a5b2df592f4b79e251e5b0d3af48265904162cb0906691a5d35ec355b426d"
  license :cannot_represent

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :linux # does not build on macOS
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"

  def install
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *std_configure_args,
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--disable-silent-rules",
                          "--disable-eaptls",
                          "--disable-peap"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pppd", "--version"
  end
end
