class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag      => "v0.11.0",
      :revision => "a4d4d94a50a19b903408825055427c44996811a0"
  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "3c7b6cfb884f469d8086cc4ca929a045f5e8cfc8643fb1a31d8d7e34ab26ddfa" => :mojave
    sha256 "248024a211f1df215b055df24d37545f71fb79af7d8283b523939b2ae4d2f37e" => :high_sierra
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
