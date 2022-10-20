class Glider < Formula
  desc "Forward proxy with multiple protocols support"
  homepage "https://github.com/nadoo/glider"
  url "https://github.com/nadoo/glider/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "a1c7032ad508b6c55dad3a356737cf05083441ea16a46c03f8548d4892ff9183"
  license "GPL-3.0-or-later"
  head "https://github.com/nadoo/glider.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8339ced3042241d3f128068b05cffc5f8f728cb6ab073272e0f76081b099b1e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffcafc5e458c78e115b94f45abfb105e69d02f7a03b5d065414fdc4b996ef251"
    sha256 cellar: :any_skip_relocation, monterey:       "8b956d24977eaf0ad44ff2112ada966d7e77d26276b6751792241bbb68d1c487"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b31c976c5a2d2c0e5e06a667cf2778c59a7d8bdf346c206efb455cce63f2232"
    sha256 cellar: :any_skip_relocation, catalina:       "20dd59e4d32da80636537d41a57ebec46944ba3754141360a7f2b7b6d5a1c5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38800c290f046908cfc31de29be0bcd4bf5f617c036a532d961d438c6004e601"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    etc.install buildpath/"config/glider.conf.example" => "glider.conf"
  end

  service do
    run [opt_bin/"glider", "-config", etc/"glider.conf"]
    keep_alive true
  end

  test do
    proxy_port = free_port
    glider = fork { exec "#{bin}/glider", "-listen", "socks5://:#{proxy_port}" }

    sleep 3
    begin
      assert_match "The Missing Package Manager for macOS (or Linux)",
        shell_output("curl --socks5 127.0.0.1:#{proxy_port} -L https://brew.sh")
    ensure
      Process.kill 9, glider
      Process.wait glider
    end
  end
end
