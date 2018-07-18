class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.7",
      :revision => "76d8a30d2307d5d4e9c1a3972808752199449694"
  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "4a89c558303b0dd7da3654f1436c2d095b1bcc85f43a80694834dd5e8f598f90" => :high_sierra
    sha256 "13677ecd641a86b9a2e87f47b5a8d5aeafc9958bb155de9b6a5351ed3d0caa61" => :sierra
    sha256 "2c4a31c5d8fc9d45a925e918c413326a8a50c29fc4641a5a20e0219cae1fb6ea" => :el_capitan
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
