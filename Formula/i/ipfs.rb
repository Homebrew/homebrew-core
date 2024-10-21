class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.31.0",
      revision: "5a32936f781ac1971899655856a2804cdf329032"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18f34c1dbd0b15a74998f5964d7118d84125b2eb7fd809ab2376ea911e362b30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16dcce902b10c82c7cf131288d87264dc111dfcda7df95220b081e53f4d91eee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48fda9ff4e60bc570f9b8f464d62c30cf3374193e06ca0cee7305dc0824f3d3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "150f555259411f1198f926eef1d7dc4ded47f4a26bdc41fc9c96e4313423352e"
    sha256 cellar: :any_skip_relocation, ventura:       "8106ef884fa45bf8cf5eeeb5d8b1c1e72b9a85882ee98fe55db46fade3e891fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "420eeda5abcf2527fe4f5bbb9003f0d2240d7ccdd4d24f52c8a0f11865514974"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion", shells: [:bash])
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
