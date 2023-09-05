class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.105.1.tar.gz"
  sha256 "68b56ba685e16971e743fca47bb636b118589dddcc302a7b74efa70e6d62cd8b"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a90e9c53e243ce496da183592858b75ac86a4069f5890a62a93ff87c096e7444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f6ba20d1a119896bdb1fdbc183ef60e2f25da10545c9ce18ebda0ba244eb0b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f61bb150aa2614b4fa395450ab55705c036bdff8feae87f4c5f011762aac75a7"
    sha256 cellar: :any_skip_relocation, ventura:        "3511cc0e1ee21131acced560137af9d9981b873962024291e86f29e65b7e2387"
    sha256 cellar: :any_skip_relocation, monterey:       "57c3a2789a2fa5437ea84147c6f3a6aba76ce696f7f774bce7b4077abd7eed5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "535b2e04a77ae544f7718202664c42cd8aee5d0ea8b61f6a57f28df45e76eec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0897bc751fd4775ee7438302bb52397260b8ad30b2fa6f537b924c7d7e02cdae"
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
