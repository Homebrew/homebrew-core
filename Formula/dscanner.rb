class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      :tag      => "v0.7.1",
      :revision => "4ad4b52c930c22a872c61efc4e5451f4b3cf9f93"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a5e5aba96d50908b8b869452915e8b048d420b9a9c625058b8709330804bf3c" => :mojave
    sha256 "0906b6577ffe7de76f44b63d8075c1aa5933e398641422ccb33ed34b68e2e968" => :high_sierra
    sha256 "35704e4cfa13e1cae87ef6204a1d96321474443a1ed25eb53474ede630e83029" => :sierra
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
