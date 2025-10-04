class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "01ecdf041a62e08297982523bfe0792e7d7024dc720b406c2a934d3b097b9781"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f9f1d356999b5417560e257a69fec27cb1850b1d99c2932ee546060f5645a11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6c9e043b45c143b0c0ece15ea5989dc812168143b7e0a8e27c026d70ee05705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77e5850097be11e038cbdce6357ac502cc58f3431fed4b8d6ff44eb395e41f30"
    sha256 cellar: :any_skip_relocation, sonoma:        "63849314073e297c7351424d9a429f5eab091c3ead430b6d1cd8de324edc95ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f4d8eba11f868498666bc895b82691debbc9f50208037232d70ebb7478f9c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b43e0e162c340d26d3ae8b979ae0ddb066254b0ae5fa927a57e9f1e5367a49c7"
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
