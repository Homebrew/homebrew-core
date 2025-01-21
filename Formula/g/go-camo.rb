class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "454e9001a55cff3fc191541bc3d17f6b95d991b5fda4fe596023aa914b332267"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b5fe9ad14fc151d2bddd05e1499bd11c78cd3c637ff35fbb9f68d793b8aef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59b5fe9ad14fc151d2bddd05e1499bd11c78cd3c637ff35fbb9f68d793b8aef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59b5fe9ad14fc151d2bddd05e1499bd11c78cd3c637ff35fbb9f68d793b8aef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "58ac230bd2ed5cf5cc440ecf5ba3383b9150881b239741a23edeac3efb2ba366"
    sha256 cellar: :any_skip_relocation, ventura:       "58ac230bd2ed5cf5cc440ecf5ba3383b9150881b239741a23edeac3efb2ba366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e44ee5ea9ea08f0fe8ad54c6941e7bcb4417a8f012367dc38744cdbb59f5b10"
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
