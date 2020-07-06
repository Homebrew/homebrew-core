class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag      => "v0.12.0",
      :revision => "09caf255e537ea832a87c9aeb7ec4ed38d751300"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "8a3b74f50717d236b6ef445de2608ab31e4c43ae10af01e71d9b95d590c4c8e7" => :catalina
    sha256 "db3e4c50f54d7dd31c9b2768d7b0539d8dea62ae0d7c3ccef7c8ce955721a595" => :mojave
    sha256 "2fa9649c94a8f624d772d76a1cd43ecc3e8b016a29711d4ea0b6e92906646f09" => :high_sierra
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
