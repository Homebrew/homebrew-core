class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.21.tar.gz"
  sha256 "070babaf736495c9d4fa6af37f3d55501572939fff92fad4ec53340b579357da"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffe13d319d94dae7602bb64dcebbeff8dc770f177110a014c51d6307315471db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffe13d319d94dae7602bb64dcebbeff8dc770f177110a014c51d6307315471db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffe13d319d94dae7602bb64dcebbeff8dc770f177110a014c51d6307315471db"
    sha256 cellar: :any_skip_relocation, ventura:        "d330a9a3e573b0031c25272b77eb0ee925cf1dcdbed7d1190eda7fde02e0ef47"
    sha256 cellar: :any_skip_relocation, monterey:       "d330a9a3e573b0031c25272b77eb0ee925cf1dcdbed7d1190eda7fde02e0ef47"
    sha256 cellar: :any_skip_relocation, big_sur:        "d330a9a3e573b0031c25272b77eb0ee925cf1dcdbed7d1190eda7fde02e0ef47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6470b1108a98a6402e21148e4e417a2cb813831c6a1fca25525dd6e55cd8402f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end
