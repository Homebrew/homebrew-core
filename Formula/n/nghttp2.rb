class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.56.0/nghttp2-1.56.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.56.0.tar.gz"
  sha256 "eb00ded354db1159dcccabc11b0aaeac893b7c9b154f8187e4598c4b8f3446b5"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "fed09dcc9c9764c4d624209763b33bfa78136cd8847ba948ed44c501b06ab1ec"
    sha256 arm64_monterey: "354731bddd11def8919a9aabbba8e6af3b3d643c6548a811fb1f148d599d3948"
    sha256 arm64_big_sur:  "6d2b03accd138d1aefce8f909306eff780516450cd5afec3143329f228fbea2e"
    sha256 ventura:        "d54b8c8749e68bb3a1a1fe451f10305f77139a403f9e65034441e4f663f47e9f"
    sha256 monterey:       "fc3a8b98e0496a36b5dfba9614b54213ad6ee38225821a6469f703b6bfc96d35"
    sha256 big_sur:        "3c269a2cbc02823f97bd955e715fb1b3309b4b5fb377932a367ebc3fead00c3e"
    sha256 x86_64_linux:   "01cbbf3a66b8e215f8968bf497dbdf31bf7d8063c739075166ee935770f8688e"
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
  depends_on "openssl@3"

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
