class Jsmin < Formula
  desc "Minify JavaScript code"
  homepage "https://www.crockford.com/javascript/jsmin.html"
  url "https://github.com/douglascrockford/JSMin/archive/1bf6ce5f74a9f8752ac7f5d115b8d7ccb31cfe1b.tar.gz"
  version "2013-03-29"
  sha256 "aae127bf7291a7b2592f36599e5ed6c6423eac7abe0cd5992f82d6d46fe9ed2d"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e471be3d192ef30727fd5f4091216cc04409092d9db4d0ecc89854a668c06afd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de5fdc649e20c4bc16bbcaff31c212e1ffe58ea1cf78df7f3a8d07f8ccbf54b1"
    sha256 cellar: :any_skip_relocation, monterey:       "2d53bf39e3018f0775f2a7967b1f4552d693dac85cda7a4b2d28d405ef234c7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb408dab6eb6250d8654237a21f841e5b30072e36a6f078d5b794bf0d0c86ca4"
    sha256 cellar: :any_skip_relocation, catalina:       "d72944720c9ec82c18cc5bba48c54292cd6ef625b5817d6493a410ce97d48a9e"
    sha256 cellar: :any_skip_relocation, mojave:         "40fb75c3bff520391b1e9c6b163f41ece401ed3aafaeb5231c3c116ffd597000"
    sha256 cellar: :any_skip_relocation, high_sierra:    "333b2cb7e9b9b575580cf9a100760641117e2c178b766eee49dcd18854f40d8f"
    sha256 cellar: :any_skip_relocation, sierra:         "21ce8792fb1bb8b004f884953b2ab97ebd0d00568f5507c3b168f594ebbbd084"
    sha256 cellar: :any_skip_relocation, el_capitan:     "7672c92faa52fbc0684808da9803ebfa8883df0e0243e63a9a0b7c6441218b85"
    sha256 cellar: :any_skip_relocation, yosemite:       "92ce35c390c8a2723e7b7cef8655e61ab9373f274c719ab4c04256cab1c42d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be5b3c13cec2e81a35231f7c40fd70ffbeaf05adca725f2194394d8815fece3"
  end

  def install
    system ENV.cc, "jsmin.c", "-o", "jsmin"
    bin.install "jsmin"
  end

  test do
    assert_equal "\nvar i=0;", pipe_output(bin/"jsmin", "var i = 0; // comment")
  end
end
