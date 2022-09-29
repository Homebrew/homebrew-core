class Dgen < Formula
  desc "Sega Genesis / Mega Drive emulator"
  homepage "https://dgen.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dgen/dgen/1.33/dgen-sdl-1.33.tar.gz"
  sha256 "99e2c06017c22873c77f88186ebcc09867244eb6e042c763bb094b02b8def61e"
  revision 1

  bottle do
    sha256 cellar: :any,                 monterey:     "1fbc47cc8c293c0c1284bdc01cb08216deabd210f806be8c4555416094a4265f"
    sha256 cellar: :any,                 big_sur:      "5b5217280e09f36cdd8650b7d0951c2a10e7996ec6bde83d90843d08e876d7b7"
    sha256 cellar: :any,                 catalina:     "3d68b5d75ca02d4686dc87be5f5d8da36925d26964aec24a6850bfccefc8a85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "55774c1de8d53707d3e330814f836d6e034a0f68f87d0507768dd0eed55f7336"
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
