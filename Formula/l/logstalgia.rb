class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"
  revision 8

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "aceca39b1516d1e6bfc99620c65f65a676571fa25ce46e0ea243fddb50298520"
    sha256 arm64_sequoia: "da2f21abb74be0c1e9a3dbc1fa88f5417616c94c62c42efa7251344deaf915ef"
    sha256 arm64_sonoma:  "5db8fa7c96b2a41a61f95dc0c1376915e4700c7908831d6f1b8f714617e94106"
    sha256 arm64_ventura: "795b3e680fcb67036bd2dab34e7456ae75a354a6b9c1446bef98aec2f315eedf"
    sha256 sonoma:        "6e56f79753a9b93c823b7cb4cf2f5cabb677c552991029803715a2befbb7e16c"
    sha256 ventura:       "6eed8631d9076c06515ec132d8aa5e662fdc0063379296151f500309e097e8b0"
    sha256 arm64_linux:   "e1c6acdf6273e0bc8c6c27d069ddf4a0b2853ea636d6a6da00e5a5231a91a45a"
    sha256 x86_64_linux:  "00b87b6d9797ceb8225ee100fa16652eba1e637f115ebe237c412f92c312319e"
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

    # Workaround for Boost 1.89.0 as upstream commit requires regenerating configure
    # https://github.com/acaudwell/Logstalgia/commit/823a1a4dbdba8f682e2d31851c11e369e50aa0f7
    if build.stable?
      odie "Remove workaround for Boost 1.89.0" if version > "1.1.4"
      ENV["with_boost_system"] = "no"
    end

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
