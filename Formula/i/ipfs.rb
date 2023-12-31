class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.25.0",
      revision: "413a52d0eed8582e4c1511e210d7e3f36fe2fe3a"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f022c753a320844ef9baa3931b36b64698d0d1db04db31737a0d3b39746acd6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b76312c278d2b2b858317dc734b91f579db2dabac92f2acc326d2f1a8a4bd9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "291d47cd5ce0c2b112ae3160b4e52a06d8ec56330340727ca2fd9b15c2229b38"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f2f67a70c345a2f78bb72e66d137bc79f9b6f034ff0c7a626f01533fb80a1fa"
    sha256 cellar: :any_skip_relocation, ventura:        "12f8e79c1b9bed6399af7ea710b0c5c207ea3e905aa20188dee7a35fc942aa85"
    sha256 cellar: :any_skip_relocation, monterey:       "b44989d35d4c88b58e32c7f54857698c748eadca0584b2fcb92eb3f7f23a6920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec2f465cb20ed3d2c55b7270103969bd4d5e38f16d81e664c27121689ca8f58"
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
