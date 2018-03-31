class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.0",
      :revision => "845f363d79c2797a0b8962bca23bf8e684284e12"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "2fffa9c9de2f698f93288d7b7ec2e3edd7169e40e54e5273fb6b3daff6823e2f" => :high_sierra
    sha256 "6f1d8437cd568e459ed227eefc3e47da9ced02fe5ec04eed13829a29726df416" => :sierra
    sha256 "efe15f951844628c959d453e601535b27fac58e67014f6d5e29ad0afc616180b" => :el_capitan
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
