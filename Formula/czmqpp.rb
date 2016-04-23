class Czmqpp < Formula
  desc "C++ wrapper for czmq"
  homepage "https://github.com/zeromq/czmqpp"
  url "https://github.com/zeromq/czmqpp.git", :revision => "5db1042"
  version "1.1.0"

  head "https://github.com/zeromq/czmqpp.git"

  option :universal

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "czmq"

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
