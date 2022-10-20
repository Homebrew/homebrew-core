class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.16.0",
      revision: "38117db6fcd76f38d9183f597739fd5be81c893f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d625a389bbb7295d316e36294ba2125f0af13a22ba7e47f7206fa1d0a8e482a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61181f4f452545a8d3c6c2fe3ec1c57bfbdfdb666f7f5d1a9894435c98ad96c1"
    sha256 cellar: :any_skip_relocation, monterey:       "66b47ac735c0c4ac7a73e04f59f8f32457b3f02fa9c213690b28cdf1f41d2b50"
    sha256 cellar: :any_skip_relocation, big_sur:        "8db0bff4b6b13239040fdf04c3d304a275844fb791f2ed9988964dd3d2ed19f1"
    sha256 cellar: :any_skip_relocation, catalina:       "2288feebe6c424425bd456994d516427aeaa350020ebc7b63d93dd1487c53589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a2f47ce6b373039bae5198a284c0a215c0ffaecac57a848dd724fe56519091"
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
