class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "http://gabedit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit248/GabeditSrc248.tar.gz"
  version "2.4.8"
  sha256 "38d6437a18280387b46fd136f2201a73b33e45abde13fa802c64806b6b64e4d3"
  revision 1

  bottle do
    cellar :any
    sha256 "76f03dc778e3379b2824c875c9eb344e8042c27fdf57f39576dcce78aa96dbb7" => :sierra
    sha256 "e8f13bf6bf5744f3439604b74c1313817dbf148b63e039e54089c10d65a818ee" => :el_capitan
    sha256 "86ef29773a913efbce0b04aef8e6abfe8c4849b02840f411f418e939da479c45" => :yosemite
    sha256 "507caa30aad09047605ca4df857b98e2c2172145d9382e8ca156fd63eeec334a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtkglext"

  def install
    args = []
    args << "OMPLIB=" << "OMPCFLAGS=" if ENV.compiler == :clang
    system "make", *args
    bin.install "gabedit"
  end

  test do
    assert (bin/"gabedit").exist?
  end
end
