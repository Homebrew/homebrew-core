class Dtools < Formula
  desc "D programming language tools"
  homepage "https://dlang.org/"
  url "https://github.com/dlang/tools/archive/refs/tags/v2.112.0.tar.gz"
  sha256 "4d3b8d683770f16f1cb2e44a246f17b199a8aabde7b6ce7d7566aebc36a12d32"
  license "BSL-1.0"
  head "https://github.com/dlang/tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "566757d9c7fabf5dcc81d5139589bf8e601370424fb8f8170ff8ea542c9f0f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fdc39e94c686ee350bf6a92dc7f331182d9fa9e14e89ee6630c7b66d0e9e1b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36c4848897bc99843bba6f6306e157c2c22b95ee4b66056573123e366ec04fcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e83e31e492dded0024a77bef1fa4916b5c4ba5b91ca12934dda63c18bc5ee35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6ab7ef6c758eb003bfcec11dcdadc10c69d6d833b90dc103d1ccb7493caa953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd470b2b653bfabec84bc5a4798f90260ec2c875c0466ec608cf63c6162209c3"
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
