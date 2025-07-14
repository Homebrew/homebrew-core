class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "973ff52e34903174c886494af755a393a456b13379883796ea268e9485fa9324"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf384e68ef94a7cdec0b4a0652aa4735c0320531051925ffaade48c6aef5a54b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc067194e69d218c4afb30f3e1ed5d8d3f2c788037dc330e281053faa0e968d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "854efaf46c811bf89ef06d0aa7819edbcfc56f19b5740180d598ff6e8b7aaf47"
    sha256 cellar: :any_skip_relocation, sonoma:        "5be83fa15e74763ca3bd95659f4438a20ab82253a2ee4f8d5674b25f2eddb489"
    sha256 cellar: :any_skip_relocation, ventura:       "2346a54b9295751f92b04f21dbff029b6b77793f6cf5dc794bb73160c86ceb88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b251da3cd29753ee6140516bdb255081d0e5f27f3e1a8b1fe307b59fc54795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1afc65000bef6d83bde5921723b8e5a3b731ba74200a5745649dd8bcf2218f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ipfs/kubo.CurrentCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion")
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output("#{bin}/ipfs init")
  end
end
