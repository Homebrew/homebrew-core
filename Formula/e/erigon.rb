class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/erigontech/erigon"
  url "https://github.com/erigontech/erigon/archive/refs/tags/v2.55.1.tar.gz"
  sha256 "2e340bb5504f565bb9fe8c4d246dea50bd54bfcf6a91e9196aeb4fbda722ae9e"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/erigontech/erigon.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "450e82a964c4c0f8091ae2ffab8cfc741e77d44c1752ee6f2eaa660044c16975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae35586de98a7067a18a36323c65a8573fd2a5cf3c4467efa1daa7f625b72edc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b3595711fe008717c82ccfa82836e9753f2319b7f66c2848ee4f891879737b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e976d99a3ee32f34a3fa3dedfc5c84dbe348781034c72ba26510c954ca1076d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fe3b15261883faf113b87f3373d9b26e4119c607c456d6ac62415974534b32e"
    sha256 cellar: :any_skip_relocation, ventura:        "6a0bbabd1ab15aa833c7311b3d13fbf176002fc5695e26ce9cf5a821f1f0e9f1"
    sha256 cellar: :any_skip_relocation, monterey:       "6e2fe466bbb29af8ef4d9d5f06767ac32188730a3bb276b9f0cfd4227ed64acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66f64987e1828b5098e40d6ec7e4fe4ece0240059d2151abca6f9959f6c88aa"
  end

  # Upstream includes pre-built libsilkworm_capi inside silkworm-go and recommends copying to installation:
  # https://github.com/erigontech/erigon?tab=readme-ov-file#how-to-run-erigon-as-a-separate-user-eg-as-a-systemd-daemon
  # Trying to build library from source only works with `conan` which would use their pre-built libraries.
  deprecate! date: "2024-02-29", because: "needs a pre-built copy of libsilkworm_capi"
  disable! date: "2025-03-04", because: "needs a pre-built copy of libsilkworm_capi"

  depends_on "gcc" => :build
  depends_on "go" => :build

  def install
    if build.stable?
      ENV["GIT_COMMIT"] = "unknown"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~JSON
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    JSON
    args = %W[
      --datadir testchain
      --log.dir.verbosity debug
      --log.dir.path #{testpath}
    ]
    system bin/"erigon", *args, "init", "genesis.json"
    assert_path_exists testpath/"erigon.log"
  end
end
