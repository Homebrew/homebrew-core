class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.6.5.tar.gz"
  sha256 "87c1e9f1dfb6de83b3ea0fc4ae90b35328772f6d841f70ae95800028f3dfd45a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df8fbb9213b66b7e3c6c553cb835b83807cc38d5c5e746442ee9ff35375847c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "25ede8217d974d6fbd22394751ec97ffb2c4a3df3d1d439e77e60c9c8da6da63"
    sha256 cellar: :any_skip_relocation, catalina:      "cee62d35e4d86cc8dce0d8e0af97a2171f49cbe7923dd6a81ba5e8b6388223c1"
    sha256 cellar: :any_skip_relocation, mojave:        "e9c1e858784a1db4dfe9c1ec028d37d012f1956842c1d1b111440372c7b999a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
