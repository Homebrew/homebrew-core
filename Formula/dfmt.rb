class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag      => "v0.9.0",
      :revision => "c3537a5d51c0d94389a5cb82dfa623726426e767"
  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "1738c3d2e31a8962dcbba54136f9ec6dc5935003203535490454f9b53c75aa09" => :mojave
    sha256 "286c00a758f14fb7719aa97c850815e7f4015b8e71e90d6c173e169df1db3d55" => :high_sierra
    sha256 "b3a530b495adafc859405d0601480a5c6cf331b73be579db185fdc8d0438b3ff" => :sierra
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
