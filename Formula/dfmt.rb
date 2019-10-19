class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag      => "v0.10.1",
      :revision => "436d157b4f5b9ab047e2207988e2416fa0b21a88"
  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "94595dfc8836d0daccf855a41c9e85aef9b123cb5a72a94323abec4bfb5e5155" => :catalina
    sha256 "3f27ea93b418c2a4c163e94f03f7aa504b2116ebc3cffa88eadd30e2075c257d" => :mojave
    sha256 "e4e2fccd219314a3797ae105c8b2a766cd5fda0da0fee2bd492e506d53f48d7a" => :high_sierra
    sha256 "a350f2837fed66d00df684f75f224da6c409ab35c12d6b125631409b1d25d0ab" => :sierra
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
