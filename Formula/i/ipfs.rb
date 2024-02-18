class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.26.0",
      revision: "096f510ab206c119693f145bc3331eeb33a69e07"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "053b914a284590b78be33d88474680557fc0ae0b40278457ab2bc20bbb73690b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d053e34b6a6b62abaf62c91d43398dd41b46d332587a7d15e9125ca0c339cf2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d4b9ab8538ca1107665a5ac4f612cc37bc601d6c7914dbff6abb77d3882ec36"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd76a63b761546ad409f45b64b4bf04c89fcd98f796f4d09d8ac9d9a82e1a361"
    sha256 cellar: :any_skip_relocation, ventura:        "cafdce733565d720757b3b443337b811db2cd7dadca42c0366bb4eacaede4f5f"
    sha256 cellar: :any_skip_relocation, monterey:       "cf7775ba5954bad653a2ebb53657d9660554d28bb9005914e49f872ac9356cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ecae1f402be9d3ec61ec0dd24145df18656ff4109649cc3229ae0d134174bf1"
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
