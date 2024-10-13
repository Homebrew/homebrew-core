class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.30.0",
      revision: "846c5ccf679eeda58e626969bee8e80685be4812"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4400a28ccefea4d9bc9c92f63c75e810ca5233c9b910a4963a9e53f31776b3af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c8d45cd077882344b77aa2858fb5743a2c2c18c4d697fb2d1823ae8fcf28fe3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "322f4e39316f5e5eaab0134ce20b3be6f72ff744a0eb0cecec3075bc2a46ae24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee0cb84873aece0c63c0581e550770ab9931c2be47b08b55b2f521a30e1130fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "28711e75ca77b12c08401e1fae54e0b722aaee029487ba7b51847df118e01806"
    sha256 cellar: :any_skip_relocation, ventura:        "ba9395ee76fd9a74bd44622dde927c31fa97f02327fc6e4e11c8a430318fd6a1"
    sha256 cellar: :any_skip_relocation, monterey:       "65306b6908cf229766fcdfb88aa727d9799a48a7edb20de3f66e453e8a257c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a0f56ac016450be431b6231679cc6ae1a900526c6d19b8b13a1337a77889ec7"
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
