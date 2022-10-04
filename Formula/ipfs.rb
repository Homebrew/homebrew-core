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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20bbc3537dbcf1b967adc0c21ac7c2a29016c3fb1220e895f7ec580967f41224"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49e28f7381907b6f081a72b923a317770b0e33d5fe9e1015f18576fc57fa4cb4"
    sha256 cellar: :any_skip_relocation, monterey:       "7cbac2ff6ca2cf1917d2b647a917601945ff4a7cd50960c28f76b5ff04a35479"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e20af6ce911d73fc5e5304b20fe44d784f473ad3109211eab7dd229a37048de"
    sha256 cellar: :any_skip_relocation, catalina:       "18fbf0dcf3a44e0e70c822bb4df944a0496905e81546b630a8944f593f9a4399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a79c98ad0011a0c05176ded94c8c63568947f53bd09ab0117b3518479990a8c"
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
