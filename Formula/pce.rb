class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  license "GPL-2.0-only"
  revision 3

  # TODO: Remove `-fcommon` workaround and switch to `sdl2` on next release
  stable do
    url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
    sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"
    depends_on "sdl12-compat"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f4bcc186e10297c857c01a2c1f49f38dd8abe2324de512253fef924664b41dc5"
    sha256 cellar: :any,                 arm64_monterey: "e91060cfda85a63fee4413b7eb726714f8775e0cd452edd0957eba43c578fdd4"
    sha256 cellar: :any,                 arm64_big_sur:  "a549787c54e01ed779ac141bf523bca16b00151802f77fa869c2f2d660dc2732"
    sha256 cellar: :any,                 ventura:        "8fa6df0cb0f1403a8f57260e983d38b7090cc7128ef5da6c8b5fe13e0918fda4"
    sha256 cellar: :any,                 monterey:       "a393cdc7dadc636acfe2f16510d4422ffd2a9fa565c094e8b82c26a7c4574456"
    sha256 cellar: :any,                 big_sur:        "84d3de8d69880534cd5a1daa04370df793e7cd81ea4c97d7146c567e904a9c28"
    sha256 cellar: :any,                 catalina:       "2d003611fb1b523196faccd42360b38a5ef955ba9a5accf213270381499c00d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8085c1b4a0418582fd72b74f50d33b8cc04d3b791ed023e1ef31b96e6a631c8f"
  end

  head do
    url "git://git.hampa.ch/pce.git", branch: "master"
    depends_on "sdl2"
  end

  depends_on "readline"

  on_high_sierra :or_newer do
    depends_on "nasm" => :build
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # src/cpu/e68000/e68000.a(e68000.o):(.bss+0x0): multiple definition of `e68_ea_tab'
    # TODO: Remove in the next release.
    ENV.append_to_cflags "-fcommon" if OS.linux? && build.stable?

    system "./configure", *std_configure_args,
                          "--without-x",
                          "--enable-readline"
    system "make"

    # We need to run 'make install' without parallelization, because
    # of a race that may cause the 'install' utility to fail when
    # two instances concurrently create the same parent directories.
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system bin/"pce-ibmpc", "-V"
  end
end
