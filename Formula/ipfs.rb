class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.18.1",
      revision: "675f8bddc18baf473f728af5ea8701cb79f97854"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0126368a62cd896b0960d2aad61f71282c71a32c8fb9066ea9b3783d58d3313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af99e9d64194a32d98dc2e70617dee65269e595e3028deb4ea14084ea145279"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a4c21b4eb107ca4110eeb8effb50d3cd7e780b072e0506cc2518d7b1ee1c638"
    sha256 cellar: :any_skip_relocation, ventura:        "8d87577f91ee6b7c14df6267e9532401e84770132a5b5b136b9a918e3b61f15c"
    sha256 cellar: :any_skip_relocation, monterey:       "6947ddc793e19504cb0cc4bf0c0337e87ee1651cfcd01e53c3c0352343d5c069"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf21f4c1e07aa18672a104f060f85184f81ea0da15b14163f2f32c7f687d8830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58ecd9f387e58a58e78ba10370fcbb1f41dbe37e0325766f5a0751a7303fd87b"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/ipfs/kubo/pull/9647
  # Remove on next release.
  depends_on "go@1.19" => :build

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
