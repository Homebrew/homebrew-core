class Dgen < Formula
  desc "Sega Genesis / Mega Drive emulator"
  homepage "https://dgen.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dgen/dgen/1.33/dgen-sdl-1.33.tar.gz"
  sha256 "99e2c06017c22873c77f88186ebcc09867244eb6e042c763bb094b02b8def61e"

  bottle do
    cellar :any
    sha256 "753f4d198c110edbcadb1b81db8200a161d67104b2e9ffa75b44d9fde6521bc0" => :catalina
    sha256 "7ebcef39d27013a647585ab076ca31fc1be468c85aeafe2d504242b4194a3d2e" => :mojave
    sha256 "bac08b08f7cfb9c108ccf0bfe2d4623324e5038f01e508c1fb5da6b3c4d58dff" => :high_sierra
    sha256 "50383807ec76387aa156cf6157ea537465bf20ad35e4e9eddda7d34685ded635" => :sierra
    sha256 "ebcab68ba8d0aa9c6aacae94d43a67ce016dcdd219c5770c3b7d6d9c3590ef9f" => :el_capitan
    sha256 "53f1fc72dbaab000eae45e143ca46a054a6ff655f91190d6aa30e71e8e505494" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/dgen/dgen.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libarchive"
  depends_on "sdl"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-sdltest
      --prefix=#{prefix}
    ]
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    If some keyboard inputs do not work, try modifying configuration:
      ~/.dgen/dgenrc
  EOS
  end

  test do
    assert_equal "DGen/SDL version #{version}", shell_output("#{bin}/dgen -v").chomp
  end
end
