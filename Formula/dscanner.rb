class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      :tag      => "v0.8.0",
      :revision => "19e9b9093a5fa33ace9ad9d3ac801a8090c18b2a"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e780997e3e575e22a399a24b69be0b2b0cab4c6e2825f487a054107e54bccdc" => :mojave
    sha256 "043e321a42654d89ab0b67649495107957d34d7841ccdbeedb79ae3e2d5aa370" => :high_sierra
    sha256 "8e9fe1d14a2a8c37401abfbc15b6c1ab5aaa2fca290f0c3986293ce196874df1" => :sierra
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
