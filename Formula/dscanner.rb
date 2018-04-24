class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.2",
      :revision => "dae286504c15b997529d3e07f37fcd177519f61f"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "70ae44dc40453d02d7864f58e6c5c4dc6303903d4d4928ff772539faf59185eb" => :high_sierra
    sha256 "a59f11ed0d0372fc64340128a0bcc3a4791db2ce50d2ceeca77d230328f549c3" => :sierra
    sha256 "d31aa7752dab773ab160f13c72125732a9cace50b86c8d389bc5a04d7c335fea" => :el_capitan
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
