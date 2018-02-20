class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.6.0",
      :revision => "e9273c169ed1ce3bbd64535f0ddec5a6f370680f"

  head "https://github.com/dlang-community/dfmt.git", :shallow => false

  bottle do
    sha256 "84f5df7c1349c5d386e58a9889c57f0c66e1ced4dedc3e4129b0334ea87990d8" => :high_sierra
    sha256 "2a3fbc12a391de3c297f379d51f7daa400457c6fc03f715d9a347292adb352c4" => :sierra
    sha256 "c1414f980bc31c286eac2144c61cc8f2ad8ef971f3076a323045e2dc0732c4c4" => :el_capitan
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
