class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.110.0.tar.gz"
  sha256 "2f1c1b29da3317321f0cf0776bdc39a682e4ef8b8bb5a919899c9a2d26e9d211"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c583c2f992c3c332b760340d2baf4a6aa6cb004eddb6b2da61960b7a48fc7fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5350f732bacaad93af5c18147b7b21cef6ca34a8641193ea2fecd32d4134195"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dab53f360a3dfa2047bb2f186ed9f41a35dbfa4efe6f871d1619676fdb765c9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c695c100c2274bd1303bb1e1fd8664689a16a62bce54c9deed538de8263df05d"
    sha256 cellar: :any_skip_relocation, ventura:       "d32eed31d7f7e167a636ba88473a66d8121e128a2024d2e2c009e58ba3ce94cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7313add8db2da9fc4d1d08fef4bc9039a79ac54cb6f0fe83c7191a0787d56aeb"
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
