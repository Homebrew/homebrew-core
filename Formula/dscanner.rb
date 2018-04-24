class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.2",
      :revision => "dae286504c15b997529d3e07f37fcd177519f61f"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "785a3d0d0438f720cae5378ae7167eaed6adf2c2827fa05eb1302921017f87d3" => :high_sierra
    sha256 "23971cb33fe2b5820140f89e453cb04c6d2c9ae59c469b4dcf6de76b592776a2" => :sierra
    sha256 "d35d75ca351f1949ecc69ec079a70c042b49fd97fdd1dcf86eecf8a52d056966" => :el_capitan
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
