class Kubo < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/releases/download/v0.43.0/kubo-source.tar.gz"
  sha256 "bcffc5ed921d395903375e8fa04f0e88f14fff16c2c4046ae84cb2bab03d8456"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1674591bcb5f30f69d6498efc7a335ca4ca0944cbb5104c17712e7353640b395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38c66cf6700971b96902c845376e2d16f2413e9f352441cac035355d8bfea01f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8e386abef0c02d1444c16319074bb9039090b7090960f89e51241bbb3454aae"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a6ec96d19bd14b050773fdfd6a0a6abfc59e408538de17a3b0f1caf23622f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c2f61002989cbb3760c58cd1e1de8abdd309b694c4afc6648eab2941e4f5f8b"
    sha256 cellar: :any,                 x86_64_linux:  "85c792f90c9d268ab9243198dc7b9b3e4d749c83b2f8c45e5c9388415ab4218a"
  end

  # TODO: unpin go@1.26 when kubo supports go 1.27
  depends_on "go@1.26" => :build

  def install
    ldflags = "-X github.com/ipfs/kubo.CurrentCommit=#{tap.user}"
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
