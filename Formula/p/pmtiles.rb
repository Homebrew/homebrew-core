class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "d1068808e3c9fbf83e057fcf6dcbe21f4719a22e766f7167b494ac954c2d06c7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8f859347aad15277cde53fda0621ab7b2647c9105456e4aed2294254b69e668"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77b1461957739b8c261b727b98fdb2669c39a056a01c1b6cf400ba0759e59849"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da17dd85210e09d29e92a10c3e87d34b88a98a8274979d8e674eba0c7d56b938"
    sha256 cellar: :any_skip_relocation, sonoma:         "2343ad8a7621ac54b567d0aca8bb385d20860aedb16f5a027c0f1e07062f67cc"
    sha256 cellar: :any_skip_relocation, ventura:        "80f8de2517e4af5db3c61443f27a0bd4d2ecfbec999807a1fdb0a2acd6d12add"
    sha256 cellar: :any_skip_relocation, monterey:       "71b995313953576fb8903e98b955fa69fcd96a01c8fa9b267f9a6dd3853fafe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e660cca9ad19c64d0e3d48f80d7ffdfaf4b68ac1f0136f7a8033ee8ab8482329"
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
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
