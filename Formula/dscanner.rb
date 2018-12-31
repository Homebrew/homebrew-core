class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      :tag      => "v0.6.0",
      :revision => "3759479d9cee8ac322aeb22f95957333e8383e34"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    sha256 "9c635a147c9936534c8bcf1df2ef92a2073170622153ea84c8c0b86494c9acc8" => :mojave
    sha256 "207fe1dd3b165c4a2b849c2c576ce385347dfcc52c73b862e46181ea4fe9f56d" => :high_sierra
    sha256 "451cdd05998052dd1fb4f7de1b2c3eb7b72c7230ee2ba7d9a2ad6c3cea30420e" => :sierra
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
