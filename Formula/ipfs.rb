class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.21.0",
      revision: "294db3e3024feef4552a58fb5ca38aef58254f12"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95e9ff4c382e6998badfe38a8e1af525f6917e10a42d7d920026bd4f6e3e4aa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbb9c454335862942a18b42f144bbd1fcbe4c86dcc9e033898894139ca1d2722"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e460eab49d33ff2dae558cf44eb6e6ec6c62cc16b5292f83c4da7a60a61cf97f"
    sha256 cellar: :any_skip_relocation, ventura:        "a82b7076ef96a91ebe67ce14ca7f876be01789968a7e039c80f8f6e7b894e50e"
    sha256 cellar: :any_skip_relocation, monterey:       "3a6a869458fddcf2fc8d62caa45949d98150f0ee4845fa251cf7302640d90640"
    sha256 cellar: :any_skip_relocation, big_sur:        "07db1298729f541421f1a225e4c2d04ed52f3c4e0a22ff4cc3588c311792841d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7685e565b829ffcd958bd25a6bcf3c7815ce82bccc9c2048b52e6ba264e63352"
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
