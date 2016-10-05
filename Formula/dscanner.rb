class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code."
  homepage "https://github.com/Hackerpilot/Dscanner"
  url "https://github.com/Hackerpilot/Dscanner/archive/v0.3.0.tar.gz"
  sha256 "2b5578ca98ad6805a1f1494dfbf90c8f491da20bfe5103ca0c8ac73d781558fe"

  bottle do
    sha256 "21462544cf3d662d79ad62fac0d27a6d6346404a4c7a58f1d0e3df86962a17b4" => :sierra
    sha256 "e4109d118bfc3ea842bf3d2aa9588dec4e5be8350557f644727b752ec261cd32" => :el_capitan
    sha256 "5f8b2e4fb9df04ba43eaba0c1f7fe53c3cee1bf71c4f23f0fcd7871c7269ba4a" => :yosemite
    sha256 "93916657176868ebab187de76075da38ef1f62e7fcf126670c297d1413c172af" => :mavericks
  end

  depends_on "dmd" => :build
  depends_on "dub" => :build

  def install
    system "dub", "build"
    bin.install "dscanner"
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    EOS

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
