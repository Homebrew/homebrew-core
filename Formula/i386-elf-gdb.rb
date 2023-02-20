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
    sha256 arm64_ventura:  "f5ccc087f76eace4b1544afe60d987f05c8052b23524040ad527ceb6ea445a3f"
    sha256 arm64_monterey: "f520ed3c18a712eed4b571785a1f192321f623590a6b8c36edd005c43ec1f053"
    sha256 arm64_big_sur:  "daebe979b8bee0deb6aa8fdbd68e7a43fe44fcac2f28bfcf6e959623111eb7ec"
    sha256 ventura:        "7a80a16a9bcb0db04abe2e62d6e6b63e1c2e8cca731c071213698678d4a5a34c"
    sha256 monterey:       "b72a57b8324ee31030aed88b6c05ab5581fec70d2ed297c170a780fc047ba109"
    sha256 big_sur:        "cea0b666233da65d7eecfaf9c7cdcaa59f16800270e2601fb9127169744097f6"
    sha256 catalina:       "a1cfbe75ae76a7e7580334e945d59a4a29bfbc3a1f4f9d9af791527cd34ed902"
    sha256 x86_64_linux:   "bb47cca7ec1eab9ef45ca0c227094c709ebfbbf56dd31014ee559ec498f5093f"
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
