class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.8.3",
      :revision => "92d5e1ac8cef71be6538d4b8dc262970cf762f0a"
  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    sha256 "037fba82a7a50a8238defa5e38550743c68ee9bc42a428036c2102e99034575c" => :mojave
    sha256 "38140acaf24162824fdfd28fdd1560bc70b536986dc8a533fb500c9df6b1dc59" => :high_sierra
    sha256 "6687428b7629139e11235138d48ac0abe1b8d153bf758ca527a8bddf0dffe6b8" => :sierra
    sha256 "ec77394a32ee77201e69eab71bed1c380d60ffb8f05190e06cc288f454e56482" => :el_capitan
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
