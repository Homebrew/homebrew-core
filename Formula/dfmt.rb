class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.7.0",
      :revision => "4168c232ab9b3698afc891a72767fc97c83345df"

  head "https://github.com/dlang-community/dfmt.git", :shallow => false

  bottle do
    sha256 "99d38d69c6ed63d1554a60a64e09a01fa36fdaaab76cec95573d5bad9143b16e" => :high_sierra
    sha256 "0b8463b0eb18ffb37ae6e375a6a548e7895365a462109e7f51d58906d765fbf1" => :sierra
    sha256 "f2527134b4bf6cb79934fc94d0f41bd126368a5f5ffeb50020d9fe0dc9f0bba9" => :el_capitan
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
