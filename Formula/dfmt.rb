class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.8.3",
      :revision => "92d5e1ac8cef71be6538d4b8dc262970cf762f0a"
  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    sha256 "45b5a58480d568b664a48a1de3bf7f6ef7c4da0414a82cec56d346fa57cef1a2" => :mojave
    sha256 "42330a2c08562028dfa6039e00298bf9a3eaaeefc052a159ebc893727fc53c07" => :high_sierra
    sha256 "0faaad2bcbecfc8c5b10cc5cef47c159718764963bcd02812d924f4f7b7dce18" => :sierra
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
