class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code."
  homepage "https://github.com/Hackerpilot/Dscanner"
  url "https://github.com/Hackerpilot/Dscanner.git",
    :tag => "v0.3.0",
    :revision => "ab08f0b28b2851063e273f5f8073b575a4d17083"

  head "https://github.com/Hackerpilot/Dscanner.git"

  bottle do
    sha256 "21462544cf3d662d79ad62fac0d27a6d6346404a4c7a58f1d0e3df86962a17b4" => :sierra
    sha256 "e4109d118bfc3ea842bf3d2aa9588dec4e5be8350557f644727b752ec261cd32" => :el_capitan
    sha256 "5f8b2e4fb9df04ba43eaba0c1f7fe53c3cee1bf71c4f23f0fcd7871c7269ba4a" => :yosemite
    sha256 "93916657176868ebab187de76075da38ef1f62e7fcf126670c297d1413c172af" => :mavericks
  end

  devel do
    url "https://github.com/Hackerpilot/Dscanner.git",
      :tag => "v0.4.0-beta.3",
      :revision => "bf3b942b9a102616c4c67611301738883845c906"
    version "0.4.0-beta.3"
  end

  depends_on "dmd" => :build

  def install
    system "make", "dmdbuild"
    bin.install "bin/dscanner"
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
