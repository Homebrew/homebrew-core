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

  livecheck do
    url "http://www.hampa.ch/pce/download.html"
    regex(/href=.*?pce[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e75f725e3f355fec9e470c79180eb547575cee5c223e58ec67c2d4affa16bc30"
    sha256 cellar: :any,                 arm64_sequoia: "e3d82bb4edc2bdcf6f53ca58219d9f750cda8e0bfea13859764900e9d143d709"
    sha256 cellar: :any,                 arm64_sonoma:  "3874dacd53efffaf435c7985575be825d3c50c64d142a4936e26dd6c22ffeb1d"
    sha256 cellar: :any,                 sonoma:        "d12b682138c89026b7cdc5b6fdeab59642b2fcc1cc23c3fbd31c6d3b5d6e30b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f04b8a55a22eed4d80da0bd08e216c4a0c1adc6c5281199fba17e59f17337257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10292a0e1101299ae6d09ea8a36478b444148da246a25fb132d2a126b082925d"
  end

  head do
    url "git://git.hampa.ch/pce.git", branch: "master"
    depends_on "sdl2"
  end

  depends_on "nasm" => :build
  uses_from_macos "libedit" # readline's license is incompatible with GPL-2.0-only

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # src/cpu/e68000/e68000.a(e68000.o):(.bss+0x0): multiple definition of `e68_ea_tab'
    # TODO: Remove in the next release.
    ENV.append_to_cflags "-fcommon" if OS.linux? && build.stable?

    if OS.mac?
      # Workaround to allow macOS libedit to be used instead of readline
      inreplace "configure", " -lhistory ", " "
    else
      ENV.append_to_cflags "-I#{Formula["libedit"].opt_libexec}/include"
      ENV.append "LDFLAGS", "-L#{Formula["libedit"].opt_libexec}/lib"
    end

    system "./configure", "--enable-readline",
                          "--without-x",
                          *std_configure_args
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
