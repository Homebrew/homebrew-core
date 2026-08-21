class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.113.0.tar.gz"
  sha256 "9fae73963d16ab7330120588c0bbbd15919de087858bfcb1d75d7cc06970179e"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce57fabe3b74014a9b10af7a84dc0f7c26909223dc12486534fc31c7b3f968ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab910b3ac80d73e1927be18ade7f8b66ffa7a02f18e2c5a1e679477883fd772c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9052bc298e193fa8c4945d2006da1bcab1ae105d9e7600ebf955e35669152e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b111c1df115cb6c1dee5d544c1b1e4274baac630f722f4505d35e6222744e5a"
    sha256 cellar: :any,                 arm64_linux:   "6a1b406dc0b848c9bfe3667d2d7357a4b95975ad12d5d38b952448a155eee1cf"
    sha256 cellar: :any,                 x86_64_linux:  "0addf6f9dcf0b96ac06eb68e69af296235a13b6b419301b9877539f45d2c74b6"
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
    (testpath/"hello.d").write <<~D
      import std.stdio;
      void main()
      {
        writeln("Hello world!");
      }
    D
    assert_equal "Hello world!", shell_output("#{bin}/rdmd #{testpath}/hello.d").chomp
  end
end
