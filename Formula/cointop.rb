class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.6.8.tar.gz"
  sha256 "ffbec93e12d62172c9859e673e7a4e49068c893450193cdea5c1f5f4a724c9f3"
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
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
