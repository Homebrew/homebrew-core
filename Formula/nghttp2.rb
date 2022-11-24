class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.51.0/nghttp2-1.51.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.51.0.tar.gz"
  sha256 "2a0bef286f65b35c24250432e7ec042441a8157a5b93519412d9055169d9ce54"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "fb429fe151edbc052bac0626bb8c965b77cb5a03532269701745f8b765b7591c"
    sha256 arm64_monterey: "fd7079661b7868aa2a5abb24df3370c08848c4e622640f0f38c03ab00a41f84c"
    sha256 arm64_big_sur:  "d42d0ed5accbbe7c4f0ccffd3a8f5ebf747abc799da8f8459000348476c3e23f"
    sha256 ventura:        "ae5de72a3407df9973e76fa8067076e87dd26345afde9cd247b812b16b6c567e"
    sha256 monterey:       "78bc8f7d368a6a08609f235f1a3b976b3dfb965e3e1bf41425952f0b089cdbb8"
    sha256 big_sur:        "f9e7779eeaa372d5514bb2de7e60a9ffad62b9bcc5ece3fe5f5baed52a754173"
    sha256 catalina:       "da5db8fdbc32ad93099bcf91313b0458f288021228681f8ce5150564e79a9c74"
    sha256 x86_64_linux:   "152bb2ac4799f90ad7245612d370064c6d0927d876483a8097219743593cff61"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Fix: shrpx_api_downstream_connection.cc:57:3: error:
  # array must be initialized with a brace-enclosed initializer
  # https://github.com/nghttp2/nghttp2/pull/1269
  patch do
    on_linux do
      url "https://github.com/nghttp2/nghttp2/commit/829258e7038fe7eff849677f1ccaeca3e704eb67.patch?full_index=1"
      sha256 "c4bcf5cf73d5305fc479206676027533bb06d4ff2840eb672f6265ba3239031e"
    end
  end

  def install
    # fix for clang not following C++14 behaviour
    # https://github.com/macports/macports-ports/commit/54d83cca9fc0f2ed6d3f873282b6dd3198635891
    inreplace "src/shrpx_client_handler.cc", "return dconn;", "return std::move(dconn);"

    # Don't build nghttp2 library - use the previously built one.
    inreplace "Makefile.in", /(SUBDIRS =) lib/, "\\1"
    inreplace Dir["**/Makefile.in"] do |s|
      # These don't exist in all files, hence audit_result being false.
      s.gsub!(%r{^(LDADD = )\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "\\1-lnghttp2", false)
      s.gsub!(%r{\$[({]top_builddir[)}]/lib/libnghttp2\.la}, "", false)
    end

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
    refute_path_exists lib
  end
end
