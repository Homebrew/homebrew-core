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
    rebuild 1
    sha256 arm64_sonoma:   "c78817b7315c2aaf671afadef0906317e6c85a1e6e76f559ab5a3e2e5947ca4b"
    sha256 arm64_ventura:  "3e37165c23e3f22c172612fa74a4603a9af1aeedea78682ac0d98adbbf52fdbe"
    sha256 arm64_monterey: "b91dfc04098ac6719f61dd66911fea230ba79ac117dfd17cdc6c8ac70d6d6bc9"
    sha256 sonoma:         "b463dc103893efb0ad468654eb722f227dd9b449434499c60eefd28c6b777c73"
    sha256 ventura:        "a03056fdbf0e878b9ba66a81c106ef5fd55022489a724e954be5e7cbb49c2b5b"
    sha256 monterey:       "af40744d71d1464260ab0e1a761aaa40bbed82fa00ac7d8bbaf45d5b0cee973b"
    sha256 x86_64_linux:   "dc88eb74b8615947f590830e07493f3d6ff8d9942cec0c5a5d61ec13c40ab705"
  end

  depends_on "arm-none-eabi-gcc" => :test
  depends_on "gmp"
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
      --prefix=#{prefix}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.12"].opt_bin}/python3.12
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
