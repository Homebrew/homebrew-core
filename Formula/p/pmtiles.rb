class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "feef16bf2aa01ea080e4b730925a6ba6433deb6d1159d836c92c28481cc3fbb1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "347a861c053678f27a508138bf4274ff5cd92b4c372b1333cf0b07c9f2f46f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "347a861c053678f27a508138bf4274ff5cd92b4c372b1333cf0b07c9f2f46f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "347a861c053678f27a508138bf4274ff5cd92b4c372b1333cf0b07c9f2f46f89"
    sha256 cellar: :any_skip_relocation, sonoma:        "a616a99898e8001a2293b744184741cecd76d5c431097efa687426a4c36a58e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b1e9d42b29ed8c99ac042d63a940e1b14482f3416d5cd9912d1d84e12840759"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
