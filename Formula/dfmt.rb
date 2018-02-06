class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.5.3",
      :revision => "6e598c197df780c8cd3496c3a663f602a2bd1e58"

  head "https://github.com/dlang-community/dfmt.git", :shallow => false

  bottle do
    sha256 "ccb9816bf837e999563e470b020b9d8b1305b2dcf2c9c8400276bf0ca766d94f" => :high_sierra
    sha256 "08ce677f6ae697ea33e29d4ecff0e419cbe71b065b8a24cb13bc65a4c5834b40" => :sierra
    sha256 "745cc85d47967fd74ad25a08dd763f028440a2c5811730c2b2c6643d7f5236b6" => :el_capitan
    sha256 "66fe1b25802b529a08f7a46e0b043fdf06e64c9fe1a48dbc04293954187b65a1" => :yosemite
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
