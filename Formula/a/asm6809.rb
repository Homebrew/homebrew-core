class Asm6809 < Formula
  desc "Cross assembler targeting the Motorola 6809 and Hitachi 6309"
  homepage "https://www.6809.org.uk/asm6809/"
  url "https://www.6809.org.uk/asm6809/dl/asm6809-2.17.tar.gz"
  sha256 "a6d36dd29cb3b26505c46595c1f0f1c4d7e66d3838f6347ce33ce27f4b35cffa"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?asm6809[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc791edd9764748c796e4f6a90e3705326600445cdf4a2eeb3fc6fd61552b920"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7de504e84b26b8234defb68bf94da035a54d7c4ac541aaf4b467089c27bd8b85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995fe91f8964623a28d85e866b283f3d530638c2315dba2ca8e5a709a3be0889"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "045d5d4372030b74a9f65153a0a985d83f1dcf74d0b6ac16c067d0ccf4d29de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c60151ade6cc3f159517932d60880ea5635ada30a038647001c0e3c3763a1267"
    sha256 cellar: :any_skip_relocation, ventura:       "60f7bbebe4678620b524fea6071a467ce5a708504e25ce932819b06eb7356bdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba890d3aebaaf8b4463b7dccf849c30fdc7be4028ac80f683421f4eca00fc3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cffd8646a3965426d5c82a4a4b846714003e0e0fc297a879f55cc5d7e8ee2dc3"
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
