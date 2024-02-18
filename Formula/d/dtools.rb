class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.107.0.tar.gz"
  sha256 "b8a848f4defd2641daf1da55863f424b2b4a48fdd10657e2b99539d9470d5738"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07c77c2d34873b4239a568735aece39a63d7104d9a6625f4603c69016a7a89bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69f1da2805566aee5fd6e7f80f73c16ef3cb470d14f803cc5d47c4de2c0c7504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4057f5222b352016d4c084bcc5397b47478b8d6f47791a4fcee1685f3df2a2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "024c7976b74908a91d39ed2613d012f1006d55c1827c22fa556f6b8bf98a763b"
    sha256 cellar: :any_skip_relocation, ventura:        "5edc9e6e6b055f1118dd7de2404d2075fb64e156ce2b7614819cab221e197271"
    sha256 cellar: :any_skip_relocation, monterey:       "05e6f9b8b7afb037ff041f6e70afca9952c1bfa6cc41bdb65dde9add57c64495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74b9afb7b99abfff1e6f078a3d9aae1ad6506e94294d9052d27083ec527db25b"
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
