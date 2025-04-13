class Asm6809 < Formula
  desc "Cross assembler targeting the Motorola 6809 and Hitachi 6309"
  homepage "https://www.6809.org.uk/asm6809/"
  url "https://www.6809.org.uk/asm6809/dl/asm6809-2.15.tar.gz"
  sha256 "7fb09e82853f49cd9cf9b6d7a54cfc92e09fbacea02b34dd813f3a51e041c914"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?asm6809[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c6ef57b6242a353744ce49ec015674cf0a90f5b58cbda4fbe3dcaacc48f1a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8961ff637c9faef483a87f88f5a83912b6890f996a180e818a53e994426bdda4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90fe61540aa6bf9dc8b1cf5653144c62c750e142c4b5287973eb36001e70da29"
    sha256 cellar: :any_skip_relocation, sonoma:        "709c34e4b22eeaafcbadf3afa236692e1164051a15ca367a4da18b7d86a3f663"
    sha256 cellar: :any_skip_relocation, ventura:       "4693ee67232d5cbc10622dc754b76faceb8db80de259c435d1e1aadc823d5070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682921f0db37c2f8023c0bdf4b426508d9bd4cf9bae7c91519d1786a883aaa03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9ef991772bb7e72626b8abbf584a04cc9e75d858a2565627e13837a4e57562"
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

    input.write <<~ASM
      ; Instructions must be preceded by whitespace
        org $c000
        lda $42
        end $c000
    ASM

    output = testpath/"a.bin"

    system bin/"asm6809", input, "-o", output
    binary = output.binread.unpack("C*")
    assert_equal [0xb6, 0x00, 0x42], binary
  end
end
