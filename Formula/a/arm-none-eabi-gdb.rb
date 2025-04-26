class ArmNoneEabiGdb < Formula
  desc "GNU debugger for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.3.tar.xz"
  sha256 "bcfcd095528a987917acf9fff3f1672181694926cc18d609c99d0042c00224c5"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "54bb4fd38fdd0c2e6b322d6ea7f05a9e101509e774b906a2048cc5a0a6df5b84"
    sha256 arm64_sonoma:  "fb92c479ff811cc52de43c83059cbfddbcdc397e39c6e79bcdafd8ac3034ef34"
    sha256 arm64_ventura: "86d36e5462f353f30a107d3e8ad067018573559d1cf6194c54826ea90d72400f"
    sha256 sonoma:        "ffddd2a96ef21bca9ca6064924f3a447a8b6eb663572bb57e587f1e772fd2cf9"
    sha256 ventura:       "bcd01adedff4f680b76b82704de6f09eb1e299c26fd4e45ab3deb377a50088cc"
    sha256 arm64_linux:   "ad9c74395a546cbe50b8bed7aa3382218326b3e1cfaa8c486d50b7de76c6f27d"
    sha256 x86_64_linux:  "9152a2b777ee25f0aace40a118467eccaed53cfdf8ba171d304c6751606812a9"
  end

  depends_on "arm-none-eabi-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.13"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Workaround for https://github.com/Homebrew/brew/issues/19315
  on_sequoia :or_newer do
    on_intel do
      depends_on "expat"
    end
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "arm-none-eabi"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --with-lzma
      --with-python=#{Formula["python@3.13"].opt_bin}/python3.13
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args, *std_configure_args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system "#{Formula["arm-none-eabi-gcc"].bin}/arm-none-eabi-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/arm-none-eabi-gdb -batch -ex 'info address _start' a.out")
  end
end
