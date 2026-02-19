class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://gource.io/"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.55/gource-0.55.tar.gz"
  sha256 "c8239212d28b07508d9e477619976802681628fc25eb3e04f6671177013c0142"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    sha256 arm64_tahoe:   "a0e923c616b9d7e20dae30ee0a12e270361c1bcad4ffa33acc95cc9106c2b2cd"
    sha256 arm64_sequoia: "4bd23512c8029667e507045a7b7a1bb9998a33486110e8ebb9bdeab9c7004b0a"
    sha256 arm64_sonoma:  "b8fb77266e58a126748b63cc5a0406c381721a6c19383b0ee47c79a09c613f6a"
    sha256 sonoma:        "5fb2eb48d4194146105a1fec6af0240966841729c6602842d805e3e6443065e6"
    sha256 arm64_linux:   "94ed2c013aed6f73eaa73ddebcf43ce498b3648906b63d83d7310adadd45d19a"
    sha256 x86_64_linux:  "e8a846b6c4a2f212ac315a701b28c2507741b8f3a6ffec6e89f4660fcac858f3"
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
    # Workaround for Boost 1.89.0 as upstream commit requires regenerating configure
    # https://github.com/acaudwell/Gource/commit/1b4e37d71506e6ad19f15190907852978507fc6a
    if build.stable?
      odie "Remove workaround for Boost 1.89.0" if version > "0.55"
      ENV["with_boost_system"] = "no"
    end

    ENV.cxx11
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
