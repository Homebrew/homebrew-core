class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.44.0/nghttp2-1.44.0.tar.xz"
  sha256 "5699473b29941e8dafed10de5c8cb37a3581edf62ba7d04b911ca247d4de3c5d"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "457a010c631153515c73fe61432b1bc5f43f47256b51fd91c499a72c238f63f0"
    sha256 big_sur:       "8db30133ceaeeb92c004d98f43d8142c499c018654dea07aae604201037af848"
    sha256 catalina:      "4029dae4ea56be84955735e6d1e9694d2bbbbbf85ffc3d0ce751d6c7d3333d74"
    sha256 mojave:        "e545859a65c983367e439d642988533a4d9c3e664a06049c29fb770c9fafdc7d"
    sha256 x86_64_linux:  "030dcffbdbe8b3495f6ede4b1dff3e5dd65a943a35413f14e69932c44a6a4ac7"
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
