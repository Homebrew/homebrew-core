class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.10.0",
      revision: "a40492bc92e86bad6441fc3aba776fe2c6a5090b"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1104121a6f2ab74f65f126502a9e0851c69fbf8a70d45de0a882e33b45155fe1" => :catalina
    sha256 "f1dbd26e0a79c660505f1e53f938afe9385670e8556156a0c4742287a815f77e" => :mojave
    sha256 "b416c8ed423b6f6ffaf0abb2e3368f5734219f8874fe11ec445a661c43fe1d61" => :high_sierra
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
