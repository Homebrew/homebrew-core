class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.55/gource-0.55.tar.gz"
  sha256 "c8239212d28b07508d9e477619976802681628fc25eb3e04f6671177013c0142"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_sequoia: "45751a1641fe7d73147fe811f8ac03d01e125dc545524fc9b130ea97714ab275"
    sha256 arm64_sonoma:  "2081d916c3ce5876f496d23ce8d6b092101aaf2750b4987c593fc52168279f2a"
    sha256 arm64_ventura: "bb6149e22c1ca5442f9974a1079a75f6ae1def91d9439b60bfe411659b9f9ad7"
    sha256 sonoma:        "163f2bc4d805804d54538f0b0c5e50ca98c8541bc05f2fae65d845a521da8d8c"
    sha256 ventura:       "1fc962a7b5587a8ce44f71c98b4966460f2b929d050a3477a3f08b878dc40c8c"
    sha256 x86_64_linux:  "01eaeab6eaaedd52c2ee0f7f7885e96357f560eb12b6b1029a5e322923128c44"
  end

  head do
    url "https://github.com/acaudwell/Gource.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
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
    system bin/"gource", "--help"
  end
end
