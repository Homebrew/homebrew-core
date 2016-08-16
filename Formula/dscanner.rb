class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code."
  homepage "https://github.com/Hackerpilot/Dscanner"
  url "https://github.com/Hackerpilot/Dscanner/archive/v0.3.0.tar.gz"
  sha256 "2b5578ca98ad6805a1f1494dfbf90c8f491da20bfe5103ca0c8ac73d781558fe"
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

    assert_match(/20/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
