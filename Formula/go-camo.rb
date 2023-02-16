class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "1182573507a50e95aa11cbd283a9d691b86b8f7c16f61b2dd7320e2aef1a2594"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0247b1b1e9df0b922a1a9a0e529f782dd87adbbfe87a80ce34f307b51eca3f61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d2635701563ffcbcca22121832e4a111c5ba80a91bf36aad4eddf50622ee5b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d2635701563ffcbcca22121832e4a111c5ba80a91bf36aad4eddf50622ee5b6"
    sha256 cellar: :any_skip_relocation, ventura:        "cac7b216c0010598501216b0599d82fdb31599493e094d2c9281efdfffa0d8cc"
    sha256 cellar: :any_skip_relocation, monterey:       "979979b03d083d27e50dcbe846b92adf47496f61c3059c76210b5c14999deff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "979979b03d083d27e50dcbe846b92adf47496f61c3059c76210b5c14999deff3"
    sha256 cellar: :any_skip_relocation, catalina:       "979979b03d083d27e50dcbe846b92adf47496f61c3059c76210b5c14999deff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bfdb3b0f091a3147ea525eeebb896e8c14f5081c6967e57e925a483a0125dfc"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "APP_VER=#{version}"
    bin.install Dir["build/bin/*"]
  end

  test do
    port = free_port
    fork do
      exec bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "http://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
