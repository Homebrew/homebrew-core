class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.13.2",
      revision: "7659b1ae1aaaeda6b787ec60a2ed1e902326d5a0"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "a372283e75b5f16695a85ebd7bbf4ae48a559fc14ad412b6fa512e154c9343c3" => :catalina
    sha256 "bf98795473d84cdc524d702a62e5d861fc10516ea908127403d6d4568cd36fc1" => :mojave
    sha256 "9f551c5d629bad54b159b0d42531df92ff54c3dfb47ae1e49dfa4235c0a043af" => :high_sierra
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
