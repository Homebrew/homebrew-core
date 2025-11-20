class Ipget < Formula
  desc "Retrieve files over IPFS and save them locally"
  homepage "https://github.com/ipfs/ipget/"
  url "https://github.com/ipfs/ipget/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "4a5016260d5a2be0f0599534f6faaaa3026131c4c13ef0ca30644d39a8ab9103"
  license "MIT"
  head "https://github.com/ipfs/ipget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e534e793352a8c580a7f5e497a74ef2c9aa5aa391355fec3adf36b2ed5d711a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f91a096af69012ce7d96dc42804505610fb701c26df6b504f3afb711e4314e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aafa5b71aa3c47d9f44363626622b12a1af7d4dc89681fac22f3f3a4a888b6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc0d36fea0b87e8915b9a32f3803721827d824eeb40b33acb5ae986be6908518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d94b8c6ea38ce71e92475d3fd1be72bb8d9a57aee730333e5caf905cf2b7b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ec55d55e12e1296df33663fd089520e312d2f3cea95518724c2a7eeddb1d154"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Make sure correct version is reported
    assert_match version.to_s, shell_output("#{bin}/ipget --version")

    # An example content identifier (CID) used in IPFS docs:
    # https://docs.ipfs.tech/concepts/content-addressing/
    cid = "bafybeihkoviema7g3gxyt6la7vd5ho32ictqbilu3wnlo3rs7ewhnp7lly"
    system bin/"ipget", "ipfs://#{cid}/"
    assert_match "JPEG image data", shell_output("file #{cid}")
  end
end
