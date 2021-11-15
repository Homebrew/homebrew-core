class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/v3.7.1.tar.gz"
  sha256 "4fc7939c708f9c8d6346430b3b90f122f2cc5e341f172f94eb711b1c48f2518a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75abd424144f5f1e31cb8584fa03aad4f28eef45b33f42def4813ddc09ce8bdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6094b78fd5c2e77ad655567d713503dee99c00e8ee4c2ef7ff38ce0bf361337"
    sha256 cellar: :any_skip_relocation, monterey:       "c640b8925c9eb63db7f5612a7a81ca15ffb8502d036aa6e4ff430fa297abb4f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fd0d56a35c640dc6731062aec132549be6bbcf1cf5fae9b089b22c07df2082a"
    sha256 cellar: :any_skip_relocation, catalina:       "0310bc54de6de7c0901d59c6177129b4d1b989e839eb7ced09b01f41398b8355"
    sha256 cellar: :any_skip_relocation, mojave:         "ee531627e5fa6a0e8ba68aeb1e7bc5c420fb307bedccbc5b8aa248b73291a665"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f6ebf8ee9bb2ff705de0f9975cc96a4284a127b093ece87b44643d83f5b636de"
    sha256 cellar: :any_skip_relocation, sierra:         "6ba3b37a9a8a0ce77430baddda0f57eebd71ad4adcf412c8f2f6b935073d7548"
  end

  resource "testfile" do
    url "https://gist.githubusercontent.com/glsorre/9f67891c69c21cbf477c6cedff8ee910/raw/84ec65cf37e0a8df5428c6c607dbf397c2297e06/pict.txt"
    sha256 "ac5e3561f9c481d2dca9d88df75b58a80331b757a9d2632baaf3ec5c2e49ccec"
  end

  def install
    system "make"
    bin.install "pict"
  end

  test do
    resource("testfile").stage testpath
    output = shell_output("#{bin}/pict pict.txt").split("\n")
    assert_equal output[0], "LANGUAGES\tCURRIENCIES"
    assert_equal output[4], "en_US\tGBP"
  end
end
