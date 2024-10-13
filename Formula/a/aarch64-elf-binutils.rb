class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia:  "a12b1c38987aced539910d0d5bcc803999f3783e4c640f366e75f3ffdf9640da"
    sha256 arm64_sonoma:   "d58aeae4ea9f3f1016c401588502c0f5908693ec904334ebcb4505564cfba1c3"
    sha256 arm64_ventura:  "4504615ff3eab4d10e2d4ea2c27e7dcf48ae6eed1f98b36869ecf42d7eafdd83"
    sha256 arm64_monterey: "fc33b4a2f5f4e7a93ea4017b1fa629ded1f4dacbb4072d9c0912ebaecf4d27a2"
    sha256 sonoma:         "c0f977599a2aedab5da2baa19e42813658143bfc11f6fbe082bb858564b21789"
    sha256 ventura:        "3509ff0abd672d5dd9f1e822f2da8815ce3a5d12dced44e68b66d8929103f55c"
    sha256 monterey:       "99158042d186229a5c35dbf47b7bbf54ed279d0195fc989412d450f3e6056124"
    sha256 x86_64_linux:   "2b9af0cd8bdfa3f67fd1bb431bef2e3507d379922d4a63864d6be56a257d1082"
  end

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
    system "./configure", "--target=#{target}",
           "--prefix=#{prefix}",
           "--libdir=#{lib}/#{target}",
           "--infodir=#{info}/#{target}",
           "--with-system-zlib",
           "--with-zstd",
           "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~EOS
      .section .text
      .globl _start
      _start:
          mov x0, #0
          mov x16, #1
          svc #0x80
    EOS
    system bin/"aarch64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{bin}/aarch64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/aarch64-elf-c++filt _Z1fv")
  end
end
