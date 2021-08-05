class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.9.1",
      revision: "dc2715af68b93611a116b83fca90714e7c5cb50b"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/go-ipfs.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f86269d9a1876e97a32c76336d2ea58d402a021c6a1cf8f670f52a91e34634c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae045bd716b0681a30c771460d551e23ed746b400e9306e6c787b8c9602b7e2e"
    sha256 cellar: :any_skip_relocation, catalina:      "ab0184411e3ca42b3836b6ada3f68deccde4ebf8eef8de147aff12949c17c1b0"
    sha256 cellar: :any_skip_relocation, mojave:        "b66473a6df6868a7b5eb26730f42908d8b949d6e1aea4fb786d1e6e46df02563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f07651c1b99b87bc12bfaac2cc2f825e507bcb75bcf504168ee66daad45adc3"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    bash_completion.install "misc/completion/ipfs-completion.bash"
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
