class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
  sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "75fca4fd07afe73b111cecc6beaa1920110df1e602d5f2152541330b3b9d08e2"
    sha256 arm64_monterey: "816819b80149e70c4b001ff0d68b02b2809c208bbf3f005729f0ce6522dfc6c7"
    sha256 arm64_big_sur:  "b3f844bdbf112b87d74c2d368071d6838747252019692b6b200bf5ae4b2003d3"
    sha256 ventura:        "1aea4eca9a82df1fbe5b05bd59663a1434aec026d9c55f77d572e48c3b0e31a8"
    sha256 monterey:       "039fa6a5d98e1e6c6bab7580d25afc6791cad9fbfe3b53ce388435e1c2fd2aa1"
    sha256 big_sur:        "5cbf1bf9d0a450e79405b239b8541cedd40619259828d2dd5cc42d53f619bce4"
    sha256 catalina:       "711d3b85605b84d64aa88cb22a0de52668e0a232345293fc3dc040fe431b9fb3"
    sha256 x86_64_linux:   "6529ba0f0d70e67b78a3e41be1200e5330550240c84c929d843e5ffb4aa4527e"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
    system "./configure", "--target=#{target}",
           "--prefix=#{prefix}",
           "--libdir=#{lib}/#{target}",
           "--infodir=#{info}/#{target}",
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
    system "#{bin}/aarch64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{bin}/aarch64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/aarch64-elf-c++filt _Z1fv")
  end
end
