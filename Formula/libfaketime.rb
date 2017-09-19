class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "http://www.code-wizards.com/projects/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.7b1.tar.gz"
  version "0.9.7b1"
  sha256 "3671511fb9e103ec0922be77efa7846aeb29a1214cf39ac3fc5a28423e392d22"
  head "https://github.com/wolfcw/libfaketime.git"

  bottle do
    rebuild 1
    sha256 "1fc4204b9cf216dffc0c614e679c37682a7702b058ca00d3aed6226220997b53" => :el_capitan
    sha256 "5148ca77b62f044e604d80cd18f2a7c46c2bd44ffff2b828eea05b98154f2b17" => :yosemite
    sha256 "9beebb4e5b6fa274f6114a141d7c20f726532e851496733b60825e9c75926480" => :mavericks
    sha256 "4b7477042b15dd475fc16de06df07e9cc3a983033d6d21ac6029dfc1ddfb1925" => :mountain_lion
  end

  depends_on :macos => :lion

  def install
    system "make", "-C", "src", "-f", "Makefile.OSX", "PREFIX=#{prefix}"
    bin.install "src/faketime"
    (lib/"faketime").install "src/libfaketime.1.dylib"
    man1.install "man/faketime.1"
  end
end
