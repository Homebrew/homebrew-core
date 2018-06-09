class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.8.1",
      :revision => "c66fea0fe546103db12d4354c2a9c73247bb9302"

  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    sha256 "c6bf8fdb51a3d3a0195a6468288d9539f8669d711b0df12eb784e5071e54bc6b" => :high_sierra
    sha256 "6e00864579a40918a9025a97b569de397a0c39d5a2f79fca78a12a79d918d922" => :sierra
    sha256 "2caa632c8b52ce5addba78e7230c9b7077117ccdeaf77209830cd97d98baeae0" => :el_capitan
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
