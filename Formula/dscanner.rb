class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.4.2",
      :revision => "401ee0e7c27fa78a032d4962baf81ec57d8a7b8f"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "1992999b88137d88b467735488407968f334d512a60bac3ee073c701680cb23c" => :high_sierra
    sha256 "65aaace66b1161c049f7821e6e720151d712d06baf46c01bbac1cb0691da5890" => :sierra
    sha256 "d24e0d2daa637315fa188b8f32abbc568c1a97cadee2f4b212ae00229a5426f2" => :el_capitan
  end

  depends_on "dmd" => :build

  def install
    system "make", "dmdbuild"
    bin.install "bin/dscanner"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    EOS

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
