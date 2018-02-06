class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.5.3",
      :revision => "6e598c197df780c8cd3496c3a663f602a2bd1e58"

  head "https://github.com/dlang-community/dfmt.git", :shallow => false

  bottle do
    sha256 "84f5df7c1349c5d386e58a9889c57f0c66e1ced4dedc3e4129b0334ea87990d8" => :high_sierra
    sha256 "2a3fbc12a391de3c297f379d51f7daa400457c6fc03f715d9a347292adb352c4" => :sierra
    sha256 "c1414f980bc31c286eac2144c61cc8f2ad8ef971f3076a323045e2dc0732c4c4" => :el_capitan
  end

  devel do
    url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.6.0-alpha.1",
      :revision => "02a735cb0c10d711c5f08fc26572f98bc5fdf0ff"
    version "0.6.0-alpha.1"
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
