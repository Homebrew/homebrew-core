class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.43.0/nghttp2-1.43.0.tar.xz"
  sha256 "f7d54fa6f8aed29f695ca44612136fa2359013547394d5dffeffca9e01a26b0f"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "e927b6ac25987d073b7d65d87bf27b30a95cd1196ffff4b5b82bf955da42b1c7"
    sha256 big_sur:       "e6112c4ce4b08b60edbb3d7fca3e22498bbe1881bd6ca95df52b9f2726b0c62a"
    sha256 catalina:      "5db5819e321f04b2301165cc267913ceacb161faa0504f4e067e074a101871b8"
    sha256 mojave:        "cbcac00ca57c0c71e148124ed31cf37abcd28f5adc11565fa51f9f277b401a09"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    # Fix: shrpx_api_downstream_connection.cc:57:3: error:
    # array must be initialized with a brace-enclosed initializer
    # https://github.com/nghttp2/nghttp2/pull/1269
    patch do
      url "https://github.com/nghttp2/nghttp2/commit/829258e7038fe7eff849677f1ccaeca3e704eb67.patch?full_index=1"
      sha256 "c4bcf5cf73d5305fc479206676027533bb06d4ff2840eb672f6265ba3239031e"
    end
  end

  def install
    # fix for clang not following C++14 behaviour
    # https://github.com/macports/macports-ports/commit/54d83cca9fc0f2ed6d3f873282b6dd3198635891
    inreplace "src/shrpx_client_handler.cc", "return dconn;", "return std::move(dconn);"

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-examples
      --disable-hpack-tools
      --disable-python-bindings
      --without-systemd
    ]

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
