class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.6.0/fuse-1.6.0.tar.gz"
  sha256 "3a8fedf2ffe947c571561bac55a59adad4c59338f74e449b7e7a67d9ca047096"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/fuse[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "a27a5c880e711be90be247febe40f5a872c2a7cd5d3a569785cde244dfabf156"
    sha256 arm64_big_sur:  "2e69fcb7757f40f65d29b4e7a62217d51c9735024906b91b5a4ccfd329836f66"
    sha256 monterey:       "a1486ffb825291ba014642a71c54d6983d5a03a144721038f7db990698e115f7"
    sha256 big_sur:        "b9bfc52e3eb1d8af025f6cc89c947ea15af0e77975ae53bf2dcef04f82d17f92"
    sha256 catalina:       "f6ec30f9ee02d5a51a6c87d7a19f6b96d771585f8b881678f143fb82fa882e38"
    sha256 x86_64_linux:   "6f86b83a89073ec0b21ab434b61cd82e87d1f32ca4232cc083a91bc021e1e7b6"
  end

  head do
    url "https://svn.code.sf.net/p/fuse-emulator/code/trunk/fuse"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "libspectrum"
  depends_on "sdl12-compat"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--with-sdl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fuse", "--version"
  end
end
