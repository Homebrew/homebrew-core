class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      :tag      => "v0.8.0",
      :revision => "19e9b9093a5fa33ace9ad9d3ac801a8090c18b2a"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5077fa951bcc4b802b4faf5e70e0a79b603f1ba7f0f7e32156c16473a056c790" => :mojave
    sha256 "c123827b04647e2e295f3f2acc79e5bc6e1d07ddb6a863ecb2b2974fdea1ac66" => :high_sierra
    sha256 "0c3600af604e121b66885a066ca2503b2ce6301c5e24b4f6198d286934a10543" => :sierra
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
