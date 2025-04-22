class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://docs.ipfs.tech/how-to/command-line-quick-start/"
  url "https://github.com/ipfs/kubo/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "297b1c85940b5894831b85ffae3acfd81ee7c4495bec5166ca1250080c44ee7a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa9247fd3a45680a7838d4b6d66758c09f18aefc85615d1dc7a98cb3bff78554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2f7540f385733884173b3513e8a11c504e7b4a4356005ee3d5f4469e5790905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "675d7dd4eedc61d603df047cf2071ab6319a0ed99c3a699b57dfd37d8a649d2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "69f5a6b93a1ece3537228b63fd41c9c8c3754e93954647289f2ca0a1f09b820b"
    sha256 cellar: :any_skip_relocation, ventura:       "b7e68e4c8583ecf9384da070cddaf554819ff8c5f52e8eb8d96fc403b81bf6de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f2ad69a69385a237e3ba6bded2f335bcc6122fab81747aa4486ee8a6b07f04d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe83850301a90dd4e7c08eda8ca5169bc05ca2e5ff504b50b26b49df2a08258c"
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
