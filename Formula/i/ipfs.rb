class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.29.0",
      revision: "3f0947b74e3b5abbce25ac910a01de6268b7dd8e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6905adef4f941167e110973199db81218cf64db1e93d7ac8b654c79076ace35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d08cf8f9903c6c1e74b637dcee95cbfde2d93c4df6cba85579b41d094d87267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebd4ca094eba5803ac088ed7c80749fbb6a024509b51cbd09f1d11eb111f542c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f35d4d8b4c9cb4d3a9671fbe48198d4b5aa037a882c4285573dc537341cbb2fa"
    sha256 cellar: :any_skip_relocation, ventura:        "6266c1e3ecc3c00cb72259e944e08b1400d9b85c1c59f08d806615f42b306d5d"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e02af657cdace060e230ed1df8817c31e56caa5832e836c164611ae4f55a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1ca4a043ebd7023c5858b465108e9c67de433999e3300ae9fce190f6399d101"
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
