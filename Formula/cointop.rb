class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/cointop-sh/cointop/archive/v1.6.9.tar.gz"
  sha256 "9f28dde6451c80cfa7ad4d3b9ecc980afea3ec3f3e9ed3934f44eb783c1d699b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e256f08652ccc9e8553f5a7059c5e1366909e214b915e07e9233f9e090b9fd7"
    sha256 cellar: :any_skip_relocation, big_sur:       "5925cc2524f811927da33686b986b942f325ade6cd1f48429743e960b050ca22"
    sha256 cellar: :any_skip_relocation, catalina:      "e826c229542d81013553ed2bd97199c43686c99bae7186f6a3c115cabfe7bad0"
    sha256 cellar: :any_skip_relocation, mojave:        "76019503a46dfc7a32e5ff4727248150ad0c2588d9877c57dc97b6465d8e07ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e14587d83b287f5b63cd2cc996532aeba3ef9dc1d44d51a666b58183ea257177"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/cointop-sh/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
