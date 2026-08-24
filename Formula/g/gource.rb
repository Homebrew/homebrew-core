class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://gource.io/"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.56/gource-0.56.tar.gz"
  sha256 "332d89b9a979b17417fbce0edd72b19914f1409fd126a13d11787d0e15dc0d79"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "cdd8bd1399f1a13c3cb16530798465f1f48b66d581fbec5ec4c88c5a69099518"
    sha256 arm64_sequoia: "e2568b1c0414ac98c980879dfcd5b95f4ab5465f24bbee26172639c2cb7852e5"
    sha256 arm64_sonoma:  "df09b9d501ec3fd2f0a1415a89d4371430b882d7b3ecd5c91556d92964a376bd"
    sha256 sonoma:        "180f834d9c4d1c87428ecbb308f673c6406e9a82b695cb21d265d8282b08876a"
    sha256 arm64_linux:   "9eee411e2d309a36a79ac43dc7e97fc67e1c739fc1bdedcc8ce3dfc494cf5451"
    sha256 x86_64_linux:  "0b072a65436f19c1c66dad5db9222dfcbf8d807488466917104b728fa4d5859e"
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
  depends_on "sdl2-compat"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{formula_opt_prefix("boost")}",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gource", "--help"
  end
end
