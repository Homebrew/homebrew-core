class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.6",
      :revision => "4b394c2a7d1a01a7279faadcbf9443e4c76dec96"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "b0300d036e13e4536a3c7e540db4cd58bde4a926497de90764aed687bfd2ec6e" => :high_sierra
    sha256 "06b92dcbf86100103ca35b3a7898165864a3b1be52f02753ef7536ec816c4b95" => :sierra
    sha256 "a89857c6f168ac0159ce7cf27bc5696ccd91b539e57d4a3919b3d71dbd50fb09" => :el_capitan
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
