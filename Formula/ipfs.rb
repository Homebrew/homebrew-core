class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.17.0",
      revision: "4485d6b71789766d36f0bdcc6d4514053f467887"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "515c219fee5f14f9361f39445e621817850280bd2b7bbf632db2584dfc4d2806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "870140073dbb06eb5fa7acc801e53ea7369625cd49bef153c51cbf3e83834e14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "135b436490698fe193b5b5c0827364ae8c2bb99d3c00f34b2a1a92af2dcc5e6f"
    sha256 cellar: :any_skip_relocation, ventura:        "954b565bfd51172f4a72ffeda5bc1dbe6b7cb6124e1746fbd67acf67029151a1"
    sha256 cellar: :any_skip_relocation, monterey:       "7eac91f7772537d1ed23e762f2be055be84db2a1cef5fa06066343cc521e1f8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d95e0b7129b7903036e964e36d4de3a889a3558d631bf8168babc1b9c6e4dfc0"
    sha256 cellar: :any_skip_relocation, catalina:       "fd98175231e48366e4ee4c17c79fa4fd350444b83127581c4efa49bb81eec5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85a87c3e9658eca526df529e836774fe492ccb3870c2b959ede5197a6135e4dc"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion", shells: [:bash])
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
