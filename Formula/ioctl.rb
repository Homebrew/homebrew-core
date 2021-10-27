class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.6.0.tar.gz"
  sha256 "dd6a8ba4c99c3bd43b2a895be01093b77aabe11c387fe2fb19fcd65a0a1149dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0dfbff6fa656e68fb0f257c6361e01491b4584696ef6cddd6fe6b2e0fb5eac9d"
    sha256 cellar: :any_skip_relocation, big_sur:       "7617036c4467c27a14034c9fbd3d8b219183dc941bffb59d37d59f60ad6c336b"
    sha256 cellar: :any_skip_relocation, catalina:      "cdfc228b1638df432318bb3206e06101922840cf5d9433e9f9b2a0ae88ed526a"
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
