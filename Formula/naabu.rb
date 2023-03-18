class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.1.3.tar.gz"
  sha256 "a8d46cde4b0f0cd6491b5c76dbd8a68dfc9480171dab4a88a05cef679d476a52"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "361ffd49122ef4e976237d6409783791b449277dee2127ee4cf62a0cdaa641d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2162db3f29e9cb45e4becccf63db3a93f00ffbe13cecde99f529ebab4c1fe17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbb44d58c041ea1b4cefdcb4d25859431adf7eb481d50bd759bfdd0b58bd4741"
    sha256 cellar: :any_skip_relocation, ventura:        "976ca1ba011367b1afa2ad9922b9fcdd4af2b73b8f0017d7b438f61f1d489614"
    sha256 cellar: :any_skip_relocation, monterey:       "72d5fa0229278c877ffe048781319412c69d14cce8e79364cb2e91cda67f7ab4"
    sha256 cellar: :any_skip_relocation, big_sur:        "19332c28c7bcb6bdf03a8af7b97bafcfcc9b42d32d388f67bd7a11fe8dec0e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8a3beb26cbb25674179abe00d2ff4569ed5cef01614b5b106724ee6992e3f85"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
