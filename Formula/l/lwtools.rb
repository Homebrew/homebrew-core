class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://www.lwtools.ca/"
  url "http://www.lwtools.ca/releases/lwtools/lwtools-4.24.tar.gz"
  sha256 "e18c01841be3b149b79df38a67b59c51247ec40df0740b972eb724a3a3c72869"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2c535cbdfccc0f0d70af61a64eaed21800db4c8874ad4749d4a5de66fffc0cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df2d82ee525776c58d4ce6a558472296880e4e188705913b14f30df5f7d9fc3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a095d8215eff8b61b2695ec8bbc9abe05f0eec83760a84ca89a5fafcc9f46ab5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ccfad0b580bd6f209e0b7a30c9dcd79f97af82736eff0fd746da510e567aa14"
    sha256 cellar: :any_skip_relocation, ventura:       "5e82da67fdba591dd1f30154d20cf56af219a6c8b28ad061f508c795c8b9f33e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0928f64aa46c2c2ef89c78918d2c0c6512a76156109fdaa49dbd2cf0ebd7b249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ae555d8339dd78feb3172793c8d69442c77297217b867a4e87fd6c40260f79c"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # lwasm
    (testpath/"foo.asm").write "  SECTION foo\n  stb $1234,x\n"
    system bin/"lwasm", "--obj", "--output=foo.obj", "foo.asm"

    # lwlink
    system bin/"lwlink", "--format=raw", "--output=foo.bin", "foo.obj"
    code = File.open("foo.bin", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0xe7, 0x89, 0x12, 0x34], code

    # lwobjdump
    assert_match(/^SECTION foo/, shell_output("#{bin}/lwobjdump foo.obj"))

    # lwar
    system bin/"lwar", "--create", "foo.lwa", "foo.obj"
    assert_match(/^foo.obj/, shell_output("#{bin}/lwar --list foo.lwa"))
  end
end
