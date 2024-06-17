class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.109.0.tar.gz"
  sha256 "eca515eb9998e4370708b576fe447820c2c328ff66d8e4cedf7132a43768f8cf"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d9bbac9059b30ccdb3c703b5b989c72a1502ac0c34dcb8e86738fa26a54386a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e37c75d5de272adb842b4732474fcc2359f7c4f10c703e9a64d1498afd30475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b372d6389382e3f188d91e0928e5c994a15def2d504eacf94ba48bd2aaf3f749"
    sha256 cellar: :any_skip_relocation, sonoma:         "3117fef6a8dd4d933e5f51f3dbd53f67852920aa027ddfeb209948f162db8a68"
    sha256 cellar: :any_skip_relocation, ventura:        "841e8d97b21984a993f11c4b30a1abd97a14dc69e332ad0647e8299f30fd79ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a8c98937790959c0b0f3bd687d1737c00c97a91ba1e9288102f2824224f235d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b557039a61adf4767bf19c8b19f7ce45ea6b5e60c3071770fd98ff7bf8a8a1"
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
