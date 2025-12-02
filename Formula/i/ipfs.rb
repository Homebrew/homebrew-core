class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "eb46fd70743049384a1b3ea8b07fa9c80db10811bc0bc64f0ba7e52d6c9d60bf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "836e6dcb2521a9ef7842455c39b2d98b36b890aabde32196405fca8353c54c35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2597b761f790adbb5611f83b6aaf07a333aff82c4c89d7134db6a6d794c648d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bed066dc60ff69686bd44f0df912f95abf484a06ce8bc4f4ff289d4854795918"
    sha256 cellar: :any_skip_relocation, sonoma:        "e73783a9e6acce1655332715bb58d673c56d41173d49daf75db7d547b6ac77d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fef5160602b9961932fc52863beaaf4c2aacc141eeee65d848a6a376c7e71b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd3f4d987ac7be44dc19b44f4c6d3e6d3a8683cfb48692bd58a6f7dc38d0a755"
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
