class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.114.0.tar.gz"
  sha256 "8d6073976664cd1294a1b98ae1cd673355557dc250713263a57a90ddec54cff0"
  license "BSL-1.0"
  compatibility_version 1
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8f5eebd9001d19c3de794d504b83203095eeb1b7be1b3f3e1614a33c9f7fcab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c61b1b7e8fdecbeef4e12d51959c076e593b2256acba6c7e27da09436790ad19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b55e9f238b3af948311be64144efaa93912bce589c7cdcf2a0893e4ba7809fb5"
    sha256 cellar: :any,                 arm64_linux:       "c5275e6525f2f1136781e4c4d178b8376d350f12e535c9a6c23f3663c7c19f82"
    sha256 cellar: :any,                 x86_64_linux:      "6d0d3512a95c9c5c68f4f860359b691a038e3d2536b8387263c435ddccc0ede0"
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
