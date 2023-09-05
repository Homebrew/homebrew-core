class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "66369652e5efe8221188517f05346279e949d1a1cd2ea6e5f138db0ac203bd23"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f83dadf6ec279142f8a0d7aad8455f147da63374c48e6e7febe2a3067fec653b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f83dadf6ec279142f8a0d7aad8455f147da63374c48e6e7febe2a3067fec653b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f83dadf6ec279142f8a0d7aad8455f147da63374c48e6e7febe2a3067fec653b"
    sha256 cellar: :any_skip_relocation, ventura:        "23b953a40b8a11955ca7674bb660550ad97a8b7b6f09d4f789c7a3c6ffe26369"
    sha256 cellar: :any_skip_relocation, monterey:       "23b953a40b8a11955ca7674bb660550ad97a8b7b6f09d4f789c7a3c6ffe26369"
    sha256 cellar: :any_skip_relocation, big_sur:        "23b953a40b8a11955ca7674bb660550ad97a8b7b6f09d4f789c7a3c6ffe26369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ed8070c0b712295da8587af234efe93edde6d5eaca31b405415b1b0005799d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "404 Not Found", output
  ensure
    Process.kill("HUP", pid)
  end
end
