class Kubo < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/releases/download/v0.43.2/kubo-source.tar.gz"
  sha256 "ac09ffea8d5e38903f8e96b3b8de63b6dd915c982718084f0079ae7a45785acc"
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
    manifest_sha256 "fb77f5e71b4de689cfe08bc012ed1ddd8fc6f53757912ded391acc031dab122f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b237e79ed92edba760ed7d52a9161946a13ecf00ed2c1e382cdae36b13f69797"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c05f79df05c60205b036a4da78b88ca9cc88148e3b22c88a7d39ecd8b069c76c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76b1571da9780eb1562669786beae41ae75d30404c718b0a47a54f7c99dccb30"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60d3a067ffc92a27389ba808a1bea05cd9703a145afa1d5efe000acae8fa6c00"
    sha256 cellar: :any,                 x86_64_linux:      "9c0448be958311b1bd7b13b4b87b5e36bcd060d4fc3a48ad18750f5e44203261"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
