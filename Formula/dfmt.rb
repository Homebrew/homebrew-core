class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.8.1",
      :revision => "c66fea0fe546103db12d4354c2a9c73247bb9302"

  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    sha256 "e96f87527c3e79924725c063f894519e95fda52794bcd61c50f3657e446fa3a3" => :high_sierra
    sha256 "773b3673e95a23bbff1d705aee6d45ff8df21522f284c57c98378a84d253b1a8" => :sierra
    sha256 "f4ab0a990a6ff1d05334bbaab1d4152eaf3b8d125f495250e7c36bb887ea88a1" => :el_capitan
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
