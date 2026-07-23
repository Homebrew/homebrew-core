class Kubo < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "8b80786f547b2afbfb0b52811462020f5c38c0887d067436238e4804f4727fc6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9dce31a2b225cc7b69c3031e4a073cc2956d220d0c9b191d5069a8314a2e833"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc02b7eed90fb66b21a9e87a7d4fdb97ba3a396adcb55a789b396959b9b58fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a711ffb354b9972cc596daaf8517a8501a3adc5ec22d9b72333f3ee7c36d26d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d97a538009a55da3c640ba03a670e7f17b9c6a716f1f4f8a00777c8d7baff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "947b7eac7747658d9d0c490caf5bf96e033540ea1e112184e2376775dd6565c2"
    sha256 cellar: :any,                 x86_64_linux:  "f7a8d32d94dbf8c6eaf6a1988e9fa41ca20312cb0e5bd0fb1952069c9118c8e3"
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
