class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "119b4bc7190741a389b005511b3014cc299cd99ca0eabb3b335a8254d46776f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6140d32439a3829573abfc18b026fbe52b4ee7b5f5de52a88fae9c400e131365"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6140d32439a3829573abfc18b026fbe52b4ee7b5f5de52a88fae9c400e131365"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6140d32439a3829573abfc18b026fbe52b4ee7b5f5de52a88fae9c400e131365"
    sha256 cellar: :any_skip_relocation, ventura:        "823c2bf79af7e637dd23665648fa42eb4238d007eb06ecc379c925b85f5075a6"
    sha256 cellar: :any_skip_relocation, monterey:       "823c2bf79af7e637dd23665648fa42eb4238d007eb06ecc379c925b85f5075a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "823c2bf79af7e637dd23665648fa42eb4238d007eb06ecc379c925b85f5075a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd2bc5159ee165c267f8db982b8b9a3678130f6914bf98aab84d659a06be1f70"
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
