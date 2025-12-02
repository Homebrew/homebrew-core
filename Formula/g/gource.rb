class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://gource.io/"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.55/gource-0.55.tar.gz"
  sha256 "c8239212d28b07508d9e477619976802681628fc25eb3e04f6671177013c0142"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 arm64_tahoe:   "6c36d1eff96ef6a9fa4498638e092b37e1fd40756b14945971c8c35639fab282"
    sha256 arm64_sequoia: "e3cbfb60306539abda03078ffef4cce6dba3caf7cf234b5c1ccf91df88ded4a2"
    sha256 arm64_sonoma:  "d019af6ea79b9221a0714d1ead5844cd60c5b83aa2e551b18e6a5b1bb8e5f923"
    sha256 arm64_ventura: "e74d52a108ee2ff08fbf08c566f16792db5e3c0c658c75f9f94b4ad1b58fe731"
    sha256 sonoma:        "392505ab1328ddcd7d644700feafb045291c697e999f69efd0f1c711f8f8fec0"
    sha256 ventura:       "0b344fc7d6eaf90a45073e1ba31ddb5a2c1148751d9053f5d10b1519e26374dc"
    sha256 arm64_linux:   "00703e4f28f180c39c8c077b39249a6d39cc4bc91e107b8bb1340c016a59de41"
    sha256 x86_64_linux:  "5f07aa25fe7a9327c789785acf848648b57a0b58b895a0bd43a28b9059e430db"
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
