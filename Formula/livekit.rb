class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "d72542c2699440805e74075825e0c1425ba039a3db6603c3f20566c8a757b3f8"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c99f9a1f71a110147f027b7d59fd7bf850342df282966d2890f1b2819cc410d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af291418147a5725d2b40ca78721e27d6c5736912d5a5ca528e91c0920ebb43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b37c99ef13c30f045a545146e0e4f576bd57335e538f693a388df355ddb0664"
    sha256 cellar: :any_skip_relocation, ventura:        "0689ed88797a8d1d850a44b31430f9e2bd72bdb7f55d220e41af7caac2876d88"
    sha256 cellar: :any_skip_relocation, monterey:       "7b5a3d906539c161bf7555c0b579742361fa923d7291ca799d04a12b619b4f04"
    sha256 cellar: :any_skip_relocation, big_sur:        "511af74b9e2c0932594158b203e93450ae0e51ad02924ad9d00b4c963920b56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a0764353c50f0f5e6e91fea2bf132d443f5c35e75ac6b459b21f47611e1d348"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    fork do
      exec bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
