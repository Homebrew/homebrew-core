class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "4bae3a7cab765e7f40e1ca45cfb15b45b7f424fc212bcd3c6c6c76aa5097b2b6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b689a3a17ed37e19332933c16f483b6007b46b6515ddbb5d8cc38ebd5381a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ccedb2294befd63d5407b815e8d9fd921ec3c8f1e55557433bff4019c3e1ae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "377378e4d401ea46f9a7b14ce55825f0266d8545aa1f475746afedf9bd8c601c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c588792a9e9ff7070d22ae00ddfa4605487ab700b2ef45247ac0e7037d177165"
    sha256 cellar: :any_skip_relocation, ventura:       "5ab524952a1e79e9563f8737aa355308c96560b5a76a68eb61e5526145c6d4a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e08365302dd8f3b8f6206f682b2bb44d54f114416e845a23802ca9d5bbb6999"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
