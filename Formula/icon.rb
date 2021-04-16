class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.20i.tar.gz"
  version "9.5.20i"
  sha256 "3ebfcc89f3f3f7acc5afe61402f6b3b168b8cd83f79021c98bbd791e92c4cbe8"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "427ea97df09541d16bb99cc53dab255578569da00e1e40cbc49691991a750916"
    sha256 cellar: :any_skip_relocation, big_sur:       "86bf64dcc7c29f0f6e20d36c135764cfa1b60381b63ff5826dbfcba9234066cd"
    sha256 cellar: :any_skip_relocation, catalina:      "8f2ea4a3265901d2bc21032d216f9191fbc9f574c4954370a24e4542e3cfaa88"
    sha256 cellar: :any_skip_relocation, mojave:        "fa51b1932b8b2a3d43cfd35bc4dea95625b2932360166fe3c5f38f4d0fc6d3ac"
  end

  def install
    ENV.deparallelize
    system "make", "Configure", "name=posix"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
