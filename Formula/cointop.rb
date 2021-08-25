class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.6.6.tar.gz"
  sha256 "f8f10ced1e46a6c7ce72875f2834f4c6116b947fa794cd078c4c4eac4c62d1f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfe1a73faed3a3dd8fc0a9683380ddf773df9c8dd9a58ab4691d9c3a8ff535f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "db47ae379ae24afbd7b85d709cb865ac90720d276a13eeb089158079212139fe"
    sha256 cellar: :any_skip_relocation, catalina:      "74ea34c1ad95044f8b37dc3cca9e834797c0e307691a973ad4bbfeb34cd469a3"
    sha256 cellar: :any_skip_relocation, mojave:        "528a51fa2c5302e59f45903f0568e1c1bb1bcba134d6226bf6e635329268235c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a8e4284946077b2c655c88829bf714e88fc98e147bed3b4d278d60d6d01953c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
