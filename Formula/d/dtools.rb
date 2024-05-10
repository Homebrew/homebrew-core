class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.108.1.tar.gz"
  sha256 "f7c216b3a3ba8456b9935ebd4eeaf3c94eb36418a10829946c6af90889a32112"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b413eca690a63aefa71ec883cab8a33ef6919e5a5ab8c69bb5e1f65bfdc6f860"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72321b83a3094f56467de2ad3a6a11ea6cbcdfd4cbcc0531a9b6cc0128c38ff7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3671676becbf89f23ca038aa66b722e88837753515bf931366b9f7fbfa4e4ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "d54bba6bb38dfee31b770bf25342915747d2dac1a1df4efaf470c112eaf099b8"
    sha256 cellar: :any_skip_relocation, ventura:        "e92956d5a6a0044b1c4171fefbb0975cd5fe0ea82e0b32d5d0a202e3369ff938"
    sha256 cellar: :any_skip_relocation, monterey:       "44268935af3971da67e900e3946313821d199f9eab7c608c747f3ead5a8ece7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1b3500feffe2f519f44b6b98327a7ce99294197e5f73ce0476fbb7d1badaaea"
  end

  depends_on "dub" => :build
  depends_on "ldc" => [:build, :test]

  link_overwrite "bin/ddemangle"
  link_overwrite "bin/dustmite"
  link_overwrite "bin/rdmd"

  def install
    # We only need the "public" tools, as listed at
    # https://github.com/dlang/tools/blob/master/README.md
    #
    # Skip building dman as it requires getting and building the DMD
    # and dlang.org source trees.
    tools = %w[ddemangle rdmd dustmite]
    system "dub", "add-local", buildpath

    tools.each do |tool|
      system "dub", "build", "--build=release", ":#{tool}"
      bin.install "dtools_#{tool}" => tool
    end

    man1.install "man/man1/rdmd.1"
  end

  test do
    (testpath/"hello.d").write <<~EOS
      import std.stdio;
      void main()
      {
        writeln("Hello world!");
      }
    EOS
    assert_equal "Hello world!", shell_output("#{bin}/rdmd #{testpath}/hello.d").chomp
  end
end
