class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.6.5.tar.gz"
  sha256 "87c1e9f1dfb6de83b3ea0fc4ae90b35328772f6d841f70ae95800028f3dfd45a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce99c2a52eb9f4484b6dfa2818364f07ebb9c92f5a930105a08126dbd94a5859"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9350b2dc213f157733a01ce156b5a19eb5a9362d5cd60490bef70e2d8ff515f"
    sha256 cellar: :any_skip_relocation, catalina:      "66c61859e21c0a1f023876ffef77d54b9a4478de175451f8f02de19263fa9afb"
    sha256 cellar: :any_skip_relocation, mojave:        "5c5deab64598bbafcfe753de6cc9189c3bd89e1db75ff0097e70281c28496812"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
