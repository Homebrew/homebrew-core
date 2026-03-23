class Kubo < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "befa8943654245abdb501535184cfe0789c14f22e59b60c80d744c9e35916147"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe00345823a6c255642b65123f7b0ffc8cf0a989f8c013915da7dc7c8b2efdd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d376cfb04356a6c2401a1a7768055935f8bb265da0896f425bff7161bdd2c64e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418f8ab5690bfd37b57d6ea51b4d8e32b9624536168bc4e81acda77ab3b51810"
    sha256 cellar: :any_skip_relocation, sonoma:        "38af8cd0ed7cff415c0dceda1ec96a7281457d8065b8acc7673005b1f534e0bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2865ccd92e5989e7e8c0e5347bcac42770b299c06067ebc7fc16c6e29568c404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b6cf942cee0b91ebdd2722b03ea2818b90dd38b411f95620bd816552a3c2347"
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
