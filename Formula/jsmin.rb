class Jsmin < Formula
  desc "Minify JavaScript code"
  homepage "https://www.crockford.com/javascript/jsmin.html"
  url "https://github.com/douglascrockford/JSMin/archive/1bf6ce5f74a9f8752ac7f5d115b8d7ccb31cfe1b.tar.gz"
  version "2013-03-29"
  sha256 "aae127bf7291a7b2592f36599e5ed6c6423eac7abe0cd5992f82d6d46fe9ed2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d72944720c9ec82c18cc5bba48c54292cd6ef625b5817d6493a410ce97d48a9e" => :catalina
    sha256 "40fb75c3bff520391b1e9c6b163f41ece401ed3aafaeb5231c3c116ffd597000" => :mojave
    sha256 "333b2cb7e9b9b575580cf9a100760641117e2c178b766eee49dcd18854f40d8f" => :high_sierra
    sha256 "21ce8792fb1bb8b004f884953b2ab97ebd0d00568f5507c3b168f594ebbbd084" => :sierra
    sha256 "7672c92faa52fbc0684808da9803ebfa8883df0e0243e63a9a0b7c6441218b85" => :el_capitan
    sha256 "92ce35c390c8a2723e7b7cef8655e61ab9373f274c719ab4c04256cab1c42d1d" => :yosemite
    sha256 "248da380666e6e08f25b75588c32d1dcad3952978e31d2a08c59c99756946bb4" => :mavericks
  end

  def install
    system ENV.cc, "jsmin.c", "-o", "jsmin"
    bin.install "jsmin"
  end

  test do
    assert_equal "\nvar i=0;", pipe_output(bin/"jsmin", "var i = 0; // comment")
  end
end
