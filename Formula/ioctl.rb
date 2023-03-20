class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.9.2.tar.gz"
  sha256 "0334f6440125a44080c8e147a08713edf3d41cfba37697eeec5a8c4c89436a37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2e58d3beab23fc94f103f0974271f24935acf1ad129122c05e2d6c108343756"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f7d0299750ff08cbabfc5b0fbb8abf33e798c4b67bade180af4e5ce17bb721"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b78ad28087c8c6325c27d95bbf0f7830c19dc086649113a6f49fcab4300c1fc"
    sha256 cellar: :any_skip_relocation, ventura:        "3e741d40c77080e5d989d3d47494ba046af02ba9e7537780686def3d7f4c644b"
    sha256 cellar: :any_skip_relocation, monterey:       "ce1a8794272c0089ee81d49fe2db69f5e2a16187e41171e0ed85e9e1f8b541af"
    sha256 cellar: :any_skip_relocation, big_sur:        "08d3c6d1d6b6c6af24d45cc4f1f8776e093a28c37b3d01fe59dbf42cfc21b043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c37a0629ad03bbe112c2568e3e5121b73c87bee2222e0e19a7534d44b2b52e"
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
