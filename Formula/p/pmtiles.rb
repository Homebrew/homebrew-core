class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "f2165529fe20d77ce7ec926a69e42bcb1e3a32d90a521374c0c96fadf831a518"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e693ff0e4d2d05c53cb7f5f5f3435fd0e5452db9ab3583e3dcbc3fb794ca806"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d843732459f07365f90e2b5da69ccfe0697ec6585a897fdab7cd74b70a4f7d9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5df133dd1cf1b1a3f0bc19d17f6bd091f1a093ba5c0fb83b4167eb3cbc4ddf86"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b99f3acf185d9fcd1867af55d3270a1a20411b82ff4d932db0f4fa48ed8b4b4"
    sha256 cellar: :any_skip_relocation, ventura:        "fe3f09bddbd957d0d791dee0d95565cd0ce0506835119d98c5790ff0fdfa9b63"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ea82d7203ea8ff13543feddb2342c3da4e4a527488c6a19b45332eb1da8b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8532ab953cc888031e5446d34c7b0b67f1fafefc6387100dc79911dab6e20ce"
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
