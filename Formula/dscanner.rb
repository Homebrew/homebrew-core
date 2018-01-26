class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.4.2",
      :revision => "401ee0e7c27fa78a032d4962baf81ec57d8a7b8f"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "04e5862c31ac11af72748a3e0cdb7ed8eea987827ad1f837934337063319b51f" => :high_sierra
    sha256 "f7b0a22b635f52dcd29d8321ba475a5ef0e88e68d279f60aea45f4296f6d2c0a" => :sierra
    sha256 "149d51495c147fab645186071409ef1ef860fd0661ce829c093aa8f320cc8299" => :el_capitan
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
