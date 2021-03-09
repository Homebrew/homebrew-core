class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.6.2.tar.gz"
  sha256 "1dad6400ea342db7a5915065788a4177221269a12ba1669bed50cdee9c97dd64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff3431d71ca12ce0ec94c592910e69548ab27636604637197c06cffb08e27ce2"
    sha256 cellar: :any_skip_relocation, big_sur:       "2093dfb9e5670f8f66f38b7f577d38787f6fb690e350eb30210f2ecceb3ee5c4"
    sha256 cellar: :any_skip_relocation, catalina:      "599bf9e1d156b4a4ad948fe3f1565810be778465918b1eafd74153b788ae05e9"
    sha256 cellar: :any_skip_relocation, mojave:        "8a924865d9b5dc65af1c75ad4cc1e4c7cc87f07083a7259cec724f1793b24541"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
