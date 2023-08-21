class ArmNoneEabiGdb < Formula
  desc "GNU debugger for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-13.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-13.2.tar.xz"
  sha256 "fd5bebb7be1833abdb6e023c2f498a354498281df9d05523d8915babeb893f0a"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_ventura:  "5b21e8a01a8dde31521c1b5311c178bb9f3dc13ea066eefd0b943c8fa805db6a"
    sha256 arm64_monterey: "444ada6aaf9b1c640f575ce7ec3dfdba04b965541976f8ccf5e1893631eb0a00"
    sha256 arm64_big_sur:  "10cbde3b5ec2f515f8d3b36ea9b710667874e4f171c75f0b64897fe4ee72ba65"
    sha256 ventura:        "99a09869b43a6c8406654c1ba2af303a53f612a441ce8a1d9d239cf1f137d294"
    sha256 monterey:       "e79801911bd93047cb34c6b01e9744fa1e73bec13279a543b38fa02f61e4d48c"
    sha256 big_sur:        "b363441c21d92cd8b01ae051634b9fe408957ba3ab28db71ba3ad820c689fdd6"
    sha256 x86_64_linux:   "c2c18bea4ea2de652d83b30658ae445dde42b513d46e7f903aa6730bf3aa2a5e"
  end

  depends_on "arm-none-eabi-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.11"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "arm-none-eabi"
    args = %W[
      --target=#{target}
      --prefix=#{prefix}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.11"].opt_bin}/python3.11
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
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
