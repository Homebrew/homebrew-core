class Dgen < Formula
  desc "Sega Genesis / Mega Drive emulator"
  homepage "https://dgen.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dgen/dgen/1.33/dgen-sdl-1.33.tar.gz"
  sha256 "99e2c06017c22873c77f88186ebcc09867244eb6e042c763bb094b02b8def61e"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f0b41b3312ecd8654034554cc0b986a8eb5d77db1a7c973f2d51aabbf6d41ac3"
    sha256 cellar: :any,                 arm64_monterey: "818fa7b9017947cead9d4b8d0ae13e940f59bce44868c41536ed6140159c8ed9"
    sha256 cellar: :any,                 arm64_big_sur:  "1107fdda6b8977cb8e962d9a7d353576f5a6e41d1de97f0c64fdfedb98253fe1"
    sha256 cellar: :any,                 ventura:        "ae26bfc0d33f0d3006fbbd752d6b7d539492fe8b27b608d42f8320ad86cde37c"
    sha256 cellar: :any,                 monterey:       "1fbc47cc8c293c0c1284bdc01cb08216deabd210f806be8c4555416094a4265f"
    sha256 cellar: :any,                 big_sur:        "5b5217280e09f36cdd8650b7d0951c2a10e7996ec6bde83d90843d08e876d7b7"
    sha256 cellar: :any,                 catalina:       "3d68b5d75ca02d4686dc87be5f5d8da36925d26964aec24a6850bfccefc8a85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55774c1de8d53707d3e330814f836d6e034a0f68f87d0507768dd0eed55f7336"
  end

  head do
    url "https://git.code.sf.net/p/dgen/dgen.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libarchive"
  depends_on "sdl12-compat"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-sdltest
      --prefix=#{prefix}
    ]
    args << "--disable-asm" if Hardware::CPU.arm?
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      If some keyboard inputs do not work, try modifying configuration:
        ~/.dgen/dgenrc
    EOS
  end

  test do
    assert_equal "DGen/SDL version #{version}", shell_output("#{bin}/dgen -v").chomp
  end
end
