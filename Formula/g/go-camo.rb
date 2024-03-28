class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.4.10.tar.gz"
  sha256 "ceae5cf677297caf85f5d929d6fdfdc37b78e0fdf21acb3dd8ed50fe3006d7f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05a3c7569ae2ffce50885e7be50693261522feba3a08ae53484f6bb1b0759985"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05a3c7569ae2ffce50885e7be50693261522feba3a08ae53484f6bb1b0759985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05a3c7569ae2ffce50885e7be50693261522feba3a08ae53484f6bb1b0759985"
    sha256 cellar: :any_skip_relocation, sonoma:         "1da5efe7eb33cff21c88ad0c71aafdced5a4a4481c1b23c00d5070a549a918fd"
    sha256 cellar: :any_skip_relocation, ventura:        "1da5efe7eb33cff21c88ad0c71aafdced5a4a4481c1b23c00d5070a549a918fd"
    sha256 cellar: :any_skip_relocation, monterey:       "1da5efe7eb33cff21c88ad0c71aafdced5a4a4481c1b23c00d5070a549a918fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47d7eaf9268bceba619b924ee06b1919ce86e46f896128fe2a8d183950eebca6"
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
