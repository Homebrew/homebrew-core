class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "9b2c0bddcc6c6f3665a06e9a8ebf3677fc220abaee18f884269a015c3677d4d8"
    sha256 arm64_sequoia: "9153cdcd4472668a94b048a6aa2fd03ce35d5faa2cf7969747477365ecb2da4a"
    sha256 arm64_sonoma:  "275b807936a511490dba76479505bb111924ab75bfb2519bbfe5623cdddc905c"
    sha256 sonoma:        "65165af052a6acb2c33b50c0eb0007b99a1fdaf50e274fef56e564cf7f343bd3"
    sha256 arm64_linux:   "69172e591a4bafb03259b705364c29a966c7f529792383c8ee38bb736c4267f4"
    sha256 x86_64_linux:  "0c6c2e5e390c81b152be94f126a906b1acaaffcddc63fd42c00e1c8b648ce376"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "arm-none-eabi"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--enable-multilib",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .text
      .globl _start
      _start:
          mov r1, #0
          mov r2, #1
          svc #0x80
    ASM

    system bin/"arm-none-eabi-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-littlearm",
                 shell_output("#{bin}/arm-none-eabi-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/arm-none-eabi-c++filt _Z1fv")
  end
end
