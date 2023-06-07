class Jsmin < Formula
  desc "Minify JavaScript code"
  homepage "https://www.crockford.com/javascript/jsmin.html"
  url "https://github.com/douglascrockford/JSMin/archive/430bfe68dc0823d8c0f92c08d426e517cbc8de5e.tar.gz"
  version "2019-10-30"
  sha256 "24e3ad04979ace5d734e38b843f62f0dc832f94f5ba48642da31b4a33ccec9ac"
  license "JSON"

  # The GitHub repository doesn't contain any tags, so we have to check the
  # date in the comment at the top of the `jsmin.c` file.
  livecheck do
    url "https://raw.githubusercontent.com/douglascrockford/JSMin/master/jsmin.c"
    regex(/jsmin\.c\s*(\d{4}-\d{1,2}-\d{1,2})/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f2ec21312b64d5a2b3bb2405dcbecf9a78b22fa3c6faa75d26c51861cbbe6d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9caafc345c169887fc5c05efbd7b4a6c67dd05355799c81be9fef87cb6e0add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edb266d3a4e8ebe1bce385a232ddd519be07dbd8a26e35d40f0db02d1ce9b198"
    sha256 cellar: :any_skip_relocation, ventura:        "d35b59cbbc22e709ce7c318c20e8a908571abcfddb0c0851e3ee7c9d9df42ebc"
    sha256 cellar: :any_skip_relocation, monterey:       "ae38034bff2af75cf7b0df7184e738cd58499d7c25fa9dcea30ca9174ba973ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "717998b8cbbcea8f6d16b8629fed8cc19b97a433b7047d1c803fb6b067fda738"
    sha256 cellar: :any_skip_relocation, catalina:       "8f9c76010cb23d67e4b63c78a9d5dc278fbd22b6f38fc4a38c40066e2c196785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a685d16de3648cae270451c662c8f1ab23bdb71d56f69b9a769273069bdff1"
  end

  def install
    system ENV.cc, "jsmin.c", "-o", "jsmin"
    bin.install "jsmin"
  end

  test do
    assert_equal "\nvar i=0;", pipe_output(bin/"jsmin", "var i = 0; // comment")
  end
end
