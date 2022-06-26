class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.8.0.tar.gz"
  sha256 "0ff566ca690801e5bdce8d24532e23a5a6e7f1969ead1e6f519651b9fabac352"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d34d850fefa331db413749bb2425cd55bca8bf719f79c5c4895394e6b0249b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f692dd0a08b8e4118738e49f1e3cb483174299c3eee7b965430654a4f31a15ef"
    sha256 cellar: :any_skip_relocation, monterey:       "829269b27b64209b07adcc76829cd526be14c2b3c5d390dfc1ba633deac524d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ef198cb3b04c5347b02d2ab487046baabca3fc0207aedee7f10213a9b61b071"
    sha256 cellar: :any_skip_relocation, catalina:       "77d9ebc493207b47919dbaec7bc74e51e2ec37014e65c195890339f2ce33156c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f5ff77d7b54d76de6f163dc57cc573aa741e3af36121254898b82f28aca0b76"
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
