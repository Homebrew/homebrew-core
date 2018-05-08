class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.3",
      :revision => "7a1050210e80f4504d5c1d4aa674093358526b0a"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "cbecdcc590267c33b641386c9dc6e8ff6586c8eaf2485742447816582a016155" => :high_sierra
    sha256 "db6aca3ac3cf46138469c1db8a4191e219c65de2690d944b89122b080945476a" => :sierra
    sha256 "0f3b31ff8d5fe80e9116e267f32596ce7980682836aae04e5e6d2172e5e894ff" => :el_capitan
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
