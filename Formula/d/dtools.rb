class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.105.2.tar.gz"
  sha256 "dc34d753742cf3c1d3612bef27862cb6930b650b99e3db847a840d2059fd0423"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81d518e2d0fc8549456b212a575342033aac5190693f17cd891a26812fa21270"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3082003c01763ca16ff51358e5d01250ff3cf73657d021bd5f714662708d0677"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0a10191cad28288d566bc4f65723d1398f18a5703821eb9880d1c04d69619d1"
    sha256 cellar: :any_skip_relocation, ventura:        "fa6237ca8240e330aac3ee3ae595227f2eed3b3a3d846d4f74676b40479ec640"
    sha256 cellar: :any_skip_relocation, monterey:       "b88490f92a9ecb8661ec8254ea7578c62f2a9206774efa2cd00380d53b890857"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f6ff75e0dadafe852bcc9144d03e6f36af6d134d7f7d27328d45fa2e0e54ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eb37c05c9c77589a3707efa178de28e6756ba528b9c9a5cce80f343e611d30d"
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
