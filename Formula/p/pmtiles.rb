class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "21f5da4802d4860b50fbd4fb59d4b2081b80fb30c33e8d4373432e23165d3dfb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcdd71956da9b00de4a1e719e1ba673efff88be1d451f900271fbd99413644d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c51964fcbfc13d9bef5e2c7317da2f732bdb3f6c97dce8c2fa507a90b22d35e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5de2f5768122d02d6238c2c7f599d5f0d49f9fe900143a4a980b19c9988adfac"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e3bca78debb39976957e5b492507ee3e9ff0db53cd9b13a96c516f88ad211e5"
    sha256 cellar: :any_skip_relocation, ventura:        "4914dbfa681bf46d7653c191d1a34e7bff89be2b9fc9980a5a9658666d6deb88"
    sha256 cellar: :any_skip_relocation, monterey:       "8d5110feede0e2410937050affedbaefec1cfe9e4a5267352cc7fa6b443cd316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a0e5363717e7e88440455e0358694a779282607495e596a5afc2a8d6a1e55cb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec bin/"pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
