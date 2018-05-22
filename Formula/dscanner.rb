class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.5",
      :revision => "e9d17fdc3bca8683b4b357c7ab821f9123897c26"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "885bdf7f9778102a925a2715c6da90ef95048ac8bd7081e2eb4be371c52b1067" => :high_sierra
    sha256 "5a47839a1c68cb0c4d1d779e0cbb0232466bd0975165a4e817ea7eef13fd9ab5" => :sierra
    sha256 "8643f4885c80787060bfc165a5abef3d8681ea1b1e25e37457dea37809da58ac" => :el_capitan
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
