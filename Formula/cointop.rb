class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/cointop-sh/cointop/archive/v1.6.9.tar.gz"
  sha256 "9f28dde6451c80cfa7ad4d3b9ecc980afea3ec3f3e9ed3934f44eb783c1d699b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e6f2702228f00ea0e33e66b57e33b6e873b04ca0ce4149e50b15d4f906f39e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ef3d48a150386e36d7cd0d19f5813de3858461d056dfb0273ba4ce968354881"
    sha256 cellar: :any_skip_relocation, catalina:      "4dbacf530ae32ca058a53a44424caf121f7f37f3c04ff5e02107a152767f1415"
    sha256 cellar: :any_skip_relocation, mojave:        "46eecd1178acc7e3653a365a732a306993316e2ad184f46860217e32c819696a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e89737e8695dfa2b27c365feeecaa6c7710d05914451cf5d502b958baab921f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/cointop-sh/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
