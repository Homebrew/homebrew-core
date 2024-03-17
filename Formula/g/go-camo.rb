class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.4.10.tar.gz"
  sha256 "ceae5cf677297caf85f5d929d6fdfdc37b78e0fdf21acb3dd8ed50fe3006d7f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "964424d6c6698fbea38c1fe7b9cd05d671fde41afbf6b8ce2c415872a7148b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "964424d6c6698fbea38c1fe7b9cd05d671fde41afbf6b8ce2c415872a7148b8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "964424d6c6698fbea38c1fe7b9cd05d671fde41afbf6b8ce2c415872a7148b8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f4a10922f1e8ef924d4888eec2d4d75b817c7e2564c0bb9543d8c2d57c2503c"
    sha256 cellar: :any_skip_relocation, ventura:        "3f4a10922f1e8ef924d4888eec2d4d75b817c7e2564c0bb9543d8c2d57c2503c"
    sha256 cellar: :any_skip_relocation, monterey:       "3f4a10922f1e8ef924d4888eec2d4d75b817c7e2564c0bb9543d8c2d57c2503c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304f4f53d4d8227a59f52792ed80ec03e0778aee63c2284d0ebd89a2b85db242"
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
