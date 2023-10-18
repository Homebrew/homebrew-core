class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.23.0",
      revision: "3a1a0413a405be6ddf22b9178461b80b980ba316"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a129c57b0fe8f9a412bd809e931ea5645429b0d825b1b651406e1e8a6fabc5d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86d31e3e41b188c737bb80de5af08914369ae2016da8424b5947eebc83156caa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6860484a00632074baeb6850bb0bd3afde8dca0a992920a83605e3f573a978b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe17fcaa6e08dd8dca8e229a37d4eed8955cff726301b2173e9defdbdfb9d191"
    sha256 cellar: :any_skip_relocation, ventura:        "0c108b0c9e4ee285a828986ccdb945e2c1a3bd114d8312747793a37f855dc38c"
    sha256 cellar: :any_skip_relocation, monterey:       "587f85221110104e3b742162635b55e85a5e69477c04c951fb939a3f7ebc37db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe520311dc789cce4d4a39162823db2bfa63b58d4f75e6b7c5b0279ef3ba926f"
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
