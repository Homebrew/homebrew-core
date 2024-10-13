class Asm6809 < Formula
  desc "Cross assembler targeting the Motorola 6809 and Hitachi 6309"
  homepage "https://www.6809.org.uk/asm6809/"
  url "https://www.6809.org.uk/asm6809/dl/asm6809-2.13.tar.gz"
  sha256 "1a5caa2ab411d6f0bdcb97004f7aa2b7f3ade0b7a281a2322380ff9fe116c6cb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8901fd3d162f677b4d92b4225cdd3495abecc0f796627b038de9404cd07b7e23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65cae1708e6590821edff4669047fe7069bffece2a10efbaa2ee89c5ca821210"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7180211e3a07280b05af16e0227b09eadf1ef0a9fcc846aa483851e5e63efd6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c1691e2574413a7d905363f77aa52f10b89e403d6de29501d84d591f6f32f74"
    sha256 cellar: :any_skip_relocation, sonoma:         "aab2f2954e025726e9c09766b73bf68ec9fdcacc8cc82f69c21819d5535cc61f"
    sha256 cellar: :any_skip_relocation, ventura:        "c58cd836c66ff7c5310c44b39da554054502fd6a90e4f52b5f4412cf195ae7ab"
    sha256 cellar: :any_skip_relocation, monterey:       "e95d6cd5f0de60c24402ca06ae6db489f9eaac86e5dbb28497f444e67949004b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "693eeed8a55936e9f34a8903365d77f197912228ff296eba98325c7b275001a0"
  end

  head do
    url "https://www.6809.org.uk/git/asm6809.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    input = testpath/"a.asm"

    input.write <<~EOS
      ; Instructions must be preceeded by whitespace
        org $c000
        lda $42
        end $c000
    EOS

    output = testpath/"a.bin"

    system bin/"asm6809", input, "-o", output
    binary = output.binread.unpack("C*")
    assert_equal [0xb6, 0x00, 0x42], binary
  end
end
