class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "http://www.code-wizards.com/projects/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.7b1.tar.gz"
  version "0.9.7b1"
  sha256 "3671511fb9e103ec0922be77efa7846aeb29a1214cf39ac3fc5a28423e392d22"
  head "https://github.com/wolfcw/libfaketime.git"

  bottle do
    sha256 "14232fbbb6c53452c81f4fb0b1cfb90930b92f643f9969a7fea9b513beb5bf54" => :sierra
    sha256 "f2cb815d9c1d79592764ad6f2a3061205679b14e056f2f8ece3451c9fe0ba1b4" => :el_capitan
  end

  depends_on :macos => :lion

  def install
    system "make", "-C", "src", "-f", "Makefile.OSX", "PREFIX=#{prefix}"
    bin.install "src/faketime"
    (lib/"faketime").install "src/libfaketime.1.dylib"
    man1.install "man/faketime.1"
  end
end
