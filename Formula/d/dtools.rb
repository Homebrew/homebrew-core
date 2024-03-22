class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.107.1.tar.gz"
  sha256 "0ecce9f981307d6330e6875d898d93e18a173d02b26733308fac8992586a72bd"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53b323fe69a5828025f4b044e28046060c2fc8f2fe20c5c94b617bd119cbcdad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f12098be44ec231cd735543015a44bf4194db94dbef449942b911531e002e7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4fd9854e447fde959b3e9089a6f13d87fdc56d12479e97daf92e66dbe7a52cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2eedd0a1ee1112dfb9625e528fdc6cda908df37e0facd454ce903a916f4c0ced"
    sha256 cellar: :any_skip_relocation, ventura:        "b8326bb35354f97577b46daa448e874155faf6da3a9be2c8ed51f3248d2e2880"
    sha256 cellar: :any_skip_relocation, monterey:       "60b28a084943049362d96411ad4079c4ce5d8f2362c89f886b0c6c0a149cd46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b9545f52556e0402d4b67ab77d73f536cb74c93d62260b065b3eacfb75e05ef"
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
