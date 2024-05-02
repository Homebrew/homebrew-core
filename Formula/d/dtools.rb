class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.108.0.tar.gz"
  sha256 "a9c02379bf4e9f2573ac8cd26b2233c7640e24c6a9b18bf164ef2c7dd8b480c2"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66fd3cc886e136ca9bf3b2c8af051ced4afdc9447b0d100fb8754c36b0aa8c97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd3e368a6cdf3233736f63150797e7e26317931ab1f48e590af5a810b8fc4f35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0275b61b39e1a9e55de83159d2531374a824ea036dae2d7624e5333883eefff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ac8e57bd820cea65d41715064468026312d281056042a1904c54076f06f36e2"
    sha256 cellar: :any_skip_relocation, ventura:        "d11f7ef326896f2d649c0f7a0e42e1df8d52eca4d19913041fd1adbf32feb5c5"
    sha256 cellar: :any_skip_relocation, monterey:       "e419cf1e236863d1191386588f97f52b6bd738810e37b81cda67af5e326ff079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d546f14c002826e6f51043485375345e2c23f2eb2cc66f19f9b8e502c815af86"
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
