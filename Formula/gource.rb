class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.53/gource-0.53.tar.gz"
  sha256 "3d5f64c1c6812f644c320cbc9a9858df97bc6036fc1e5f603ca46b15b8dd7237"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_ventura:  "0fed73bab25233076f066e7ff220c27fe67f9bd31e6412081e3c67b015e3666e"
    sha256 arm64_monterey: "6b9c5e1ff77e77ecae8a3994478dcd0e596e0e4a5ec728b72f750ee95987a595"
    sha256 arm64_big_sur:  "663179151f975d5a4ad660e82aaba10349572fc4753efc7e40d6b7889c87e9dd"
    sha256 ventura:        "775f2c53867041f5e8ed676a77097b7234fccab31589c4f7e908c088fde52114"
    sha256 monterey:       "1c585257f8a5364f280aa5150dc32f949b2dc340be2f996c905590c2cc0bc379"
    sha256 big_sur:        "5bdde0885f86eb1acf021a4f9784c7e74272edc564a64215582d0019193bc9c2"
    sha256 x86_64_linux:   "aa1391cdddf7f25199f8603fc92dc3e2ba3ad66175b1e4b5acff68e79e7c7e1d"
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

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    system "#{bin}/gource", "--help"
  end
end
