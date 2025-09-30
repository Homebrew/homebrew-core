class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "1370b8f91613c49c3fdc105a3da11fc0e227451b5254361930db7985ce164688"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34dc371c6ac83e058930ac1ccf997087bb0e7e6e8f7196c0e70234b9c28da14e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8bc1a2645bdc9af35be144effc47901a3d047eb0be45048e58073947860e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e8bc1a2645bdc9af35be144effc47901a3d047eb0be45048e58073947860e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e8bc1a2645bdc9af35be144effc47901a3d047eb0be45048e58073947860e2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "47005fff64af2bdf2beab3ea2e2bf467482bd2875588147cb605245e28e930ae"
    sha256 cellar: :any_skip_relocation, ventura:       "47005fff64af2bdf2beab3ea2e2bf467482bd2875588147cb605245e28e930ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37b0e3d13c68dcd29b7e1d7f8d86cd700ffa4b280dd7beb2d1b2991074565ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab171130aa6ba1bbb43531db83a7911b9b679fe782f442e7f5e4afb40f68ea5"
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

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
