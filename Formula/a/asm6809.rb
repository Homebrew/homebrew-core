class Asm6809 < Formula
  desc "Cross assembler targeting the Motorola 6809 and Hitachi 6309"
  homepage "https://www.6809.org.uk/asm6809/"
  url "https://www.6809.org.uk/asm6809/dl/asm6809-2.14.tar.gz"
  sha256 "c7b5c8a17f329a88c8ec466ebf000047879bab3716f7df2ed2579e2623f22c0c"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?asm6809[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c6f5c6fa28e50311352db7cb70d61249b3599f8b503d251f1b2eb4556af5806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "440d94ef4c3690acade80e470c130b75fd1cae46fcd4dd8fd5f2e11f1189382d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b111e038025e87b3807110d05c09aa0dcd3447724ab8d43acc9bc815948e2582"
    sha256 cellar: :any_skip_relocation, sonoma:        "d32c8faaedd4d50873f97c5bff6a3a73a5ffa41bf8fe5e4022d401273f0603a3"
    sha256 cellar: :any_skip_relocation, ventura:       "76cdcd5a6f3ba1ae307387f6e5549070d749857609cbe2a319ea056867df6116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "120c79fe414840ab14ae87b675c6b83d5128dd377feabb11d937821d47996985"
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
