class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.6.1",
      :revision => "4725a622c6f4312d309f6cf857556cb07bad75b5"

  head "https://github.com/dlang-community/dfmt.git", :shallow => false

  bottle do
    sha256 "7b47d17d0366eb50efde5726ad0c111b55693aa11d0364d3614af076de83eea7" => :high_sierra
    sha256 "470617f0ce3a8579a28a702fd15037dd77146ffc00ff2c4c80d81bf2ad1a015f" => :sierra
    sha256 "feb7ba0a96a1e93b67ec451937f47fbf9e38bab4a337bfe2a716a9cdd0197369" => :el_capitan
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dfmt"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio; void main() { writeln("Hello, world without explicit compilations!"); }
    EOS

    expected = <<~EOS
      import std.stdio;

      void main()
      {
          writeln("Hello, world without explicit compilations!");
      }
    EOS

    system "#{bin}/dfmt", "-i", "test.d"

    assert_equal expected, (testpath/"test.d").read
  end
end
