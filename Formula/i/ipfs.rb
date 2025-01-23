class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.32.1",
      revision: "901745353f3b14b3dbf295a6d3f5f98a5a2ce38f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59616a47887d20d48e2b349b402a5df78d61e9401478a55f2422e4c60cb73667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28055da0f805aef41fa41de454be1a6cd54d0b9f53e9e166fb9719e898792f0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbf41acc432ce512fdf264f3cb126520929fe8ed4bbd5c22ee262dda7551a64e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c557aa0ed4ad4e372fb9c3b99046e0758c0f4ce9093cccef595d182ccbca1846"
    sha256 cellar: :any_skip_relocation, ventura:       "b92abcb9223dfabd68ffbecf0501e6e8703d07217811f0a59f2caf6041cda26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcdd084e1ac3f4f11cbecb0d261da25fb1ac66844771f510be70151173a21dba"
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
