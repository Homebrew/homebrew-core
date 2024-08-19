class ArmNoneEabiGdb < Formula
  desc "GNU debugger for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-15.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-15.1.tar.xz"
  sha256 "38254eacd4572134bca9c5a5aa4d4ca564cbbd30c369d881f733fb6b903354f2"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "1f2012ea2f5c260fb5403802612d9f67caf6049aa0941b4e2623f3d4d802e145"
    sha256 arm64_ventura:  "dd0f5fd927cc14f6d445edc65ccc2b74d5cd17ba3bbda0dff0c6bd7b6fda5088"
    sha256 arm64_monterey: "3419beec438e06d8a30b95dc62055f57ff61fd2b18b48945c485801496a8651a"
    sha256 sonoma:         "3b5d49f771d77f4848fbc910de65aeb60b41f776d6a3dbf7e81e4045c3eb0977"
    sha256 ventura:        "fb66b64cea0bb9a72f28d9405ec616f5390c02791f984db1a414f1a3a5b6d2b4"
    sha256 monterey:       "d648d0e4d2a1117ed0f9b9f091cedf3c99a994837667dec9da1bbbc4f79c2e96"
    sha256 x86_64_linux:   "655212621e11ca1ba708b18fb42402be25b0bb7ea572de0e8bbb5353bab15aa1"
  end

  depends_on "arm-none-eabi-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

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
      --with-python=#{Formula["python@3.12"].opt_bin}/python3.12
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
