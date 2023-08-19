class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.105.0.tar.gz"
  sha256 "4775807baa07acc4ad576a14507fc0d94cacd80fba2369679ffd01415716ed98"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7803975882b442103cdf8d17d27539590377a6eeda3163e8cf8ebb051f709c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eee71030279b7a55c94effc6f71c7f41a6db0c71536356ac101b31e5d5974f93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ef4742bbe3c409b449d0ea578a18a98118a2cbb1067a91d2a471e2ca75add84"
    sha256 cellar: :any_skip_relocation, ventura:        "11b7fe8f734151cb1676cd298c758d1e1036f977d1ead01e1919ddc7a547cb2f"
    sha256 cellar: :any_skip_relocation, monterey:       "0e1024608dce16e87ac5833e154cad19743a1ce10dc9d4cfcb77f008ae0ddffe"
    sha256 cellar: :any_skip_relocation, big_sur:        "61ac5baf9bf4de9cdd2cf3e5e1c3d5258a24ab84a50c241555325baefadc67f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f46294681c518759d08b9dab30b46b71814d45f1d476603bdb65c6270d989aa1"
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
