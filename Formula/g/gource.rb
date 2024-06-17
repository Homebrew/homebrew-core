class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.54/gource-0.54.tar.gz"
  sha256 "1dcbcedf65d2cf4d69fe0b633e54c202926c08b829bcad0b73eaf9e29cd6fae5"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 arm64_sonoma:   "0a22e1eeb613eeeb43e82650c78058db8f9be241ca52588f235267f0137aff8e"
    sha256 arm64_ventura:  "bfb3df79badebd7b21308e65225c1ca9026c40cf75faf1d5b924149195766004"
    sha256 arm64_monterey: "6d038b9f738420539f7cc32362a9c1074afa26a0f46880dfb6e623f27d51998f"
    sha256 sonoma:         "e5c26a4251e5975fd8301c01299b6a8a5a4d2a848843086e2c8f415ee5d6ccac"
    sha256 ventura:        "af0c1dae247b7069be63625b50fb95e1aa598855a344da4aeac5060a3f156d82"
    sha256 monterey:       "c1012016e7b681774b17458008744399dcb61b551b3b6c5876b6ad54db22c03f"
    sha256 x86_64_linux:   "54663e308e0755e3e7b992985d36b91f859d2bfb2b0dbc82a2690d836569c851"
  end

  head do
    url "https://github.com/acaudwell/Gource.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  # Fix build with `boost` 1.85.0 using open PR.
  # PR ref: https://github.com/acaudwell/Gource/pull/326
  patch do
    url "https://github.com/acaudwell/Gource/commit/4357df0e3cf3a5f2c8bcff74bf562e5f346c930a.patch?full_index=1"
    sha256 "8c566c312e18ee293eb1cf14864b6c3658cfcc971eaf887ee0d308b67572c3e6"
  end

  def install
    ENV.cxx11

    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/gource", "--help"
  end
end
