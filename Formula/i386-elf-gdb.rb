class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-13.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-13.1.tar.xz"
  sha256 "115ad5c18d69a6be2ab15882d365dda2a2211c14f480b3502c6eba576e2e95a0"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_ventura:  "4be9ac9fa46e1d773439c98eb9954a0f3936a4078b0730fd9027e78bd54ce5d4"
    sha256 arm64_monterey: "7b61b62dd24a24a1cae2df2189a59c88cc69992deca68f31d96d04c62859b3be"
    sha256 arm64_big_sur:  "2d9becacbafc6e1a0445e051436db5a0f705416bea2718fc1aa8c58723923cd6"
    sha256 ventura:        "9ec0af5a616c593fe827a18fb3662b238f6f32804ace9238e52493bd1690b0b9"
    sha256 monterey:       "179bf1ec5aa1b8b487409d37ceadd88916da0bd02c3e680fed54807594755569"
    sha256 big_sur:        "85524bbb1ec85ebc9d6d35137c0982d2a36ad4f72c2541e2efc72125e344726a"
    sha256 x86_64_linux:   "95dea0e6ed65f9d4891137b54214d1ef339bb39d25b305c2364cdb169188ae74"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.11"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "i386-elf"
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
    system Formula["i686-elf-gcc"].bin/"i686-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
                 shell_output("#{bin}/i386-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
