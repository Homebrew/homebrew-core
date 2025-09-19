class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "f5b23c8f55f356993f936a310576f89a3cb4c66f4eb0cc68c41131869acf1495"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50e2bedd1131db64a48ec4d53d084c1b0d50e04a16ede5be3627151399a7dd05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98afd2b09b16f4b9140d10864f195d6edd14354ceea09b9085f3d3974b945ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b865ec1e28f9bb7a7a8907f68cb18f15fd3f51105eb8bcb150b285dc484c457"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e9ead66ba829901299cc65635dd1065f633a90c9b241b2de9973ddea1001d4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "24d50ac2fd715d558e744de85404bf13e400035edbececa613039ff90332f3ed"
    sha256 cellar: :any_skip_relocation, ventura:       "dffd7a012f863db3c8c87a34b27e7caef0299927cd50d44fe008465ab01bab8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "170dc727a32d2fb5339489fa8b53fd6fe766c4793697c367a0c7327dbe67188c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233a63cfd4332289986dd8a5b8fbef3652d90b4718c30269c27545a3b542ae62"
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
