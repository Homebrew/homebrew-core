class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "b0ecf8837fc0ef7fdf1fc2145a28e7246dd0bafcb64037bfb8dd6a4e393a1b0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c109736fe43f92e4283f9da9fa3a472f75324f6a78b421ffcf0aa288bb24247"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c109736fe43f92e4283f9da9fa3a472f75324f6a78b421ffcf0aa288bb24247"
    sha256 cellar: :any_skip_relocation, monterey:       "9aeb1790075eb725a34e3d5f07901a65c27ca98a6821316918a817949f378432"
    sha256 cellar: :any_skip_relocation, big_sur:        "9aeb1790075eb725a34e3d5f07901a65c27ca98a6821316918a817949f378432"
    sha256 cellar: :any_skip_relocation, catalina:       "9aeb1790075eb725a34e3d5f07901a65c27ca98a6821316918a817949f378432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48c7f81d8f6e30bc86dab0a26bdb20b545d8b4f9e98e73e1f29efb894330c32a"
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
