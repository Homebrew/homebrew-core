class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    sha256 arm64_sequoia: "221c64339ccde05aa3c801dee8b6b622a413e02eb8dc5b518c557b355d274597"
    sha256 arm64_sonoma:  "ad28ec258c7b1719cccc9e5c0fcec798ab2ffd38ce69fd94b9f05d2d5ea23cba"
    sha256 arm64_ventura: "c067670175d1f468fb49ce3c8358f2a591bac1cca15bc1e9a1c9a37d3a1d94de"
    sha256 sonoma:        "fd5806743b355f6106ded586a2447df24681cbb66b259c48141492350070eb7e"
    sha256 ventura:       "3acf2aaaffda836946cb952e0cc463b92ba958a3791e3f1719ce57e09071c774"
    sha256 x86_64_linux:  "b95612106ad5cb74aeb54a1d355a57c7a8953a80d775e781e46274116a3c5d82"
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git", branch: "master"

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
    ENV.cxx11 # to build with boost>=1.85

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--without-x",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
