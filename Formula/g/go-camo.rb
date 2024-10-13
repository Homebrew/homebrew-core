class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "c6491a9364e621da6a2f204b2bc77aac14eb7d0eba895bd5c60240853d572f4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fe93419ffa43e642d2079e69daf962440bb629c57cddc2b84c2301ae8af3807a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e88abfca2c294c8966ab21d0fece9b7a0117461a81508cee2cf39f4de790978"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e88abfca2c294c8966ab21d0fece9b7a0117461a81508cee2cf39f4de790978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e88abfca2c294c8966ab21d0fece9b7a0117461a81508cee2cf39f4de790978"
    sha256 cellar: :any_skip_relocation, sonoma:         "68c115ff6731fff9e5f84b0d4894bd22f52afaae67b2fcdf4c9e40b23f43016e"
    sha256 cellar: :any_skip_relocation, ventura:        "68c115ff6731fff9e5f84b0d4894bd22f52afaae67b2fcdf4c9e40b23f43016e"
    sha256 cellar: :any_skip_relocation, monterey:       "68c115ff6731fff9e5f84b0d4894bd22f52afaae67b2fcdf4c9e40b23f43016e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eebd364b64215bf9b2a06f64edc58078c21ac9ca6d039985b3b6e1c8edb90ae"
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
