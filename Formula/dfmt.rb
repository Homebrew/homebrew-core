class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.13.0",
      revision: "b5dbb0e031d411bb94c8784f52eebbe474583755"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "70a01e51339a8bbc3d72c4927a3016227b8aea5fbe9238e1f8c9240b7c3effbf" => :catalina
    sha256 "97a07085db537c652c1b3afe994eae61e3df931a184a72e1515feae1ea2988b7" => :mojave
    sha256 "3e5fb65962d1e76dc734123b14de06001498b416f8dfb1c765994d18d68da285" => :high_sierra
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
