class Asm6809 < Formula
  desc "Cross assembler targeting the Motorola 6809 and Hitachi 6309"
  homepage "https://www.6809.org.uk/asm6809/"
  url "https://www.6809.org.uk/asm6809/dl/asm6809-2.16.tar.gz"
  sha256 "6051624597d94d69a68a08e194cfe18cbdb12f829c80d92b84f641794b8b09bb"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?asm6809[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53a922bce5c9ecde31b6f3a8e387f1db2d31649b8e0ddccdfc3d8825b5743eb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6589664a9e6e8ca18926cc88dd3afa2fd0c493126351e78acde2a5d48be1307"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0a0771b53895adaede7849139df909fab2ac61dc1ebdc5d3b0f805cdff43cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b89cdd10721a6e83b487022edeefc95433f089ed6778110a96a032b893d7a6"
    sha256 cellar: :any_skip_relocation, ventura:       "53e5901547c33f9d32dfff01cbee8a14267320b40ad99dc01d206df3ccbdf0a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d0ec076c8403a105d75e020c8bdc9118bd40320122c66c5e430a88fe9e2ea53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbf6e55fa95c5e75aa42a332602abde9188dbb7700ae2758b556f30884addb4e"
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
