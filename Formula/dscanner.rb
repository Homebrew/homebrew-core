class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code."
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
    :tag => "v0.4.0",
    :revision => "87e42ae1941aeda81cc8e6c4343ab3c8d77036cd"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "bc3c0bc25628531eb5a5f0273c861c3f3c8cfcea0d3c79464be315db53243fde" => :high_sierra
    sha256 "cee064b929cb506b88e7bed826e94ec8b8ffbf04e19767f6c10a8a816007978b" => :sierra
    sha256 "01f7abb878de76d8d6617c285edbe035e11c5ea35964b9d79edab28c96429cc2" => :el_capitan
    sha256 "c7ab84fde1c0551f7a61b2e833cb62c085923680a614a6a1ce5101143753eff8" => :yosemite
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
