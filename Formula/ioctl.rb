class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.9.2.tar.gz"
  sha256 "0334f6440125a44080c8e147a08713edf3d41cfba37697eeec5a8c4c89436a37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d569b61be050de300480e90a07ffcac861a570ae9149349a10348c23e52c690a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f46469c9bc5fa76dfe11951944396237d35b555386cafe2f6a1483c7245aa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ac078ecf7a66c7c76da2fa40eae9cb3084f2388f701156f2cd7b3fc46deca3a"
    sha256 cellar: :any_skip_relocation, ventura:        "2236f656f814a67d15294e819869f05e5503ad2b96e7e9570e72aa07ee632a10"
    sha256 cellar: :any_skip_relocation, monterey:       "ba423ebb959ed5fd8ab74a923bdd556c4df9741f58c8558232063afc65ae245f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e131e8e90e8082157f7bf3f706e07e452957c07a1e1564bc957911134350eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df3bcdcaaa044c80d252dfcd391c90cb3188ed197074b2b69d3b14f966a65385"
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
