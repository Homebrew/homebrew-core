class Dgen < Formula
  desc "Sega Genesis / Mega Drive emulator"
  homepage "https://dgen.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dgen/dgen/1.33/dgen-sdl-1.33.tar.gz"
  sha256 "99e2c06017c22873c77f88186ebcc09867244eb6e042c763bb094b02b8def61e"

  bottle do
    sha256 cellar: :any,                 monterey:     "56176497529b9b9e348c9f81e8e3eaa35a02a86d8158d6eaf9083d2506b43e90"
    sha256 cellar: :any,                 big_sur:      "476760ba116d162e64497c9bfec9e8222f55b455c31083269789057a76776228"
    sha256 cellar: :any,                 catalina:     "753f4d198c110edbcadb1b81db8200a161d67104b2e9ffa75b44d9fde6521bc0"
    sha256 cellar: :any,                 mojave:       "7ebcef39d27013a647585ab076ca31fc1be468c85aeafe2d504242b4194a3d2e"
    sha256 cellar: :any,                 high_sierra:  "bac08b08f7cfb9c108ccf0bfe2d4623324e5038f01e508c1fb5da6b3c4d58dff"
    sha256 cellar: :any,                 sierra:       "50383807ec76387aa156cf6157ea537465bf20ad35e4e9eddda7d34685ded635"
    sha256 cellar: :any,                 el_capitan:   "ebcab68ba8d0aa9c6aacae94d43a67ce016dcdd219c5770c3b7d6d9c3590ef9f"
    sha256 cellar: :any,                 yosemite:     "53f1fc72dbaab000eae45e143ca46a054a6ff655f91190d6aa30e71e8e505494"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d6e7a76934be220bc54372894c23fd17a56eafad2e7baf6c8c551a789c6eb47b"
  end

  head do
    url "https://git.code.sf.net/p/dgen/dgen.git", branch: "master"

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
