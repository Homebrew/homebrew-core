class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.113.1.tar.gz"
  sha256 "d225f5436d3fd1bc06dbe7839e9e38f81e2510ad1a497ce4ab294800ccc42806"
  license "BSL-1.0"
  compatibility_version 1
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5dc0f6227ee3484ebb0fb7932da6da30e3371559b7c9bdfcb2fe02e229caed83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c11580f33d09c09ae254bb0f312f7a7ee854d5c253344574e368f24b1a6bb225"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6939dcf366172f5df04740af834d518aadba6aa751fdb5ce7259c42fb3a7debb"
    sha256 cellar: :any,                 arm64_linux:       "d74f59533587bff375a1ea7b5f876c69af1abb5326965233b537c0d7c23bc000"
    sha256 cellar: :any,                 x86_64_linux:      "b8a5cd8be61b4314c6eca2d13ac14d0d58a4c60850fd614919e30e77e11382cd"
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
