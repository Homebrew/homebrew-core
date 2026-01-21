class Kubo < Formula
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fafb4b11cd40c9552ff50782000b4cd3582b742995d27da775c44e8a9ebee94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e55dad3da85e1983f50f3039dc46a88e8ddb449a7850593e2aff3009f2137593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdef8ec73d0ce0f5a690a229930c8d9648c3598402aed43dbdb6ff60745ceafc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ea3fe7f705fcf2425ec60f485b7df938c3f2a5f6c3096d11150f041e2ec1b8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f0196e054936ae401b64ec8541c615c4319aa608e7b4684b9d672b6c8ab92a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f9e599789c54d8b74054a8701d927601d76f7440e49503035c0092e752585b"
  end

  depends_on "go" => :build

  # bump cockroachdb/swiss for Go 1.26 support, upstream pr ref, https://github.com/ipfs/kubo/pull/11124
  patch do
    url "https://github.com/ipfs/kubo/commit/ecf967de3a0ac32c0e2c4f2391518b64741376df.patch?full_index=1"
    sha256 "2ed099b25219f9fde686461e684ff8fbe26fb8ab66b2e6cb213975e84e82dee1"
  end

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
