class Kubo < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "e9f6056c4d66da55f2632ec814f2d3d8dc61d8d97b9e4d2f0ed4cfa5a9d63537"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37f5dbc50e7f6783ae7964128d57da8b2ee4dc76b3a7cdd41ea4e63a99356708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51f32b605d44e4ac2dd7c034ad725a5edf640ccf25ad568e8c5fcc9e21f116b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b9903d3b654416b4113e220a90c4391cf3cb4879ef037a3909796b46a8f3609"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb425c48b7955ec36dd97ac2839610c98b3b9f8ed647f8d9015929a534709216"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91dc48d6fc1d8e70d53b89004f03bbcffaa130511c3cd7455c3604fa32d9b03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd1f7667174afa2a2b4b41ef86374fcede775c04124b559f425adf01bda64a66"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ipfs/kubo.CurrentCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ipfs"), "./cmd/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion")
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output("#{bin}/ipfs init")
  end
end
