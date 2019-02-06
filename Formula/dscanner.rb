class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      :tag      => "v0.6.0",
      :revision => "3759479d9cee8ac322aeb22f95957333e8383e34"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3553bc82dbf0730fd847d12358886a7991f2922d4973742cf06b7cfea8d3f6d" => :mojave
    sha256 "18048d735a5b5b742c50386fe787ada697aaecbbfee198f369cb68565d1f11cc" => :high_sierra
    sha256 "f6907427563b4ef09eb4650a4013c2effc3b4010ab499ef285ef8a95bbe75d82" => :sierra
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
