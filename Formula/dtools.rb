class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.104.1.tar.gz"
  sha256 "3013074eb6770ecb0ee33869f2215a8b84be4b07a8b5c39baa673ca716011210"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca635afa25d55e396dfc938d75814bd0792441ef5c5084adf3a4120c2f55dd4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f1ca011200cba1f94801bd966449959e2721cfe90e416388f1cae78904264e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b34a2a51274421c01de68417519cb5b30259378b8247946506f81369db2df62"
    sha256 cellar: :any_skip_relocation, ventura:        "cb442c1a4a52570cba487d443b1a1951c092ce8c2ec806aac74cf56a7c4e2c84"
    sha256 cellar: :any_skip_relocation, monterey:       "a25977b3ad70ce753d92a30d25bc73d83681b55b17791ca9348ce01d62246c84"
    sha256 cellar: :any_skip_relocation, big_sur:        "1000f6704a06939406ed415fd50becfd988a00b1979ec34d8790459685f6d648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f15ecdb8aeb12d6c7b8299edaea757f2bd09e8e2c8f8f31818cac510c5f6eca"
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
