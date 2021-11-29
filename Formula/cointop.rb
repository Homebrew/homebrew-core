class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/cointop-sh/cointop/archive/v1.6.10.tar.gz"
  sha256 "18da0d25288deec7156ddd1d6923960968ab4adcdc917f85726b97d555d9b1b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ee93ff4d71ee6d9418e972e03b2793267e809ddfefad226c4768ad64fcba1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62a9c420f36752b3b4acdab93f96f98566822661e9e4c75e404be233c15c6823"
    sha256 cellar: :any_skip_relocation, monterey:       "09cf270f0ac715952792f39d40dc95929c6fe9d423baf6214f17e48c6ef231d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "effcf6142cf4adc9b7c21e86c9c74e8b8d0105fef747729d61dafc66e644d1dd"
    sha256 cellar: :any_skip_relocation, catalina:       "4b2b50933313c695c883709e5d0bdb03508a5fb0e20ca1c600679cb0038ffd53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3ba671173b8fc6902baf83ab7d6f921758bf09d07f905d780d19d6753259f38"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/cointop-sh/cointop/cointop.version=#{version}")
  end

  test do
    system bin/"cointop", "test"
  end
end
