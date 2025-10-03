class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.111.0.tar.gz"
  sha256 "4c391349e929f73b7ffe97da7b98fbbdb04effda3e6389d9d46dc9d9938ece3b"
  license "BSL-1.0"
  revision 1
  head "https://github.com/dlang/tools.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "274178ae030c4b9871cbdd75b0a4325d8d7017a60d0fc443c1c94c8049eec142"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f6645e51b5da22628b3b64b43acafc4ac335b98afbe8cbee3d10ef88fdaec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e3f2aed17e75ef0632e0ec36b9dfb3db9566af400d3e2ec027aa89bf1699234"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ffb209a7cc7a4e05c90771030c6c91941be35dd9884fe58f9dd14ef82c5fce1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b01da4e8af6781c0a9333fc0e27fbcd2b758e0e9a99fc49a6a3123f0a1725d2"
    sha256 cellar: :any_skip_relocation, ventura:       "7fbe7a851ed67642ac50e8a196ac216278eb7528f4c150360c9d4a219be3d30f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d8fd7789bb36d3a8577f925224336d7bc6cd2b891b9065a81d91b6e97b7b73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb2ded59c5d481a4ef6d450a65ac15bdf527b9d56ab89bc293fbd68f9c6a180"
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
