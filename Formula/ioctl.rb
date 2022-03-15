class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.7.0.tar.gz"
  sha256 "074df1fae35423f099520f74a63e2c55b22d57ac6b542a04d9e9d84e27d26bb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "336f634e6f72bcb1f082c11b50b064871125fce98142ecbd600cf1c35408106d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e57f20ed0ebb4735ddf634ac80c8e0089b556f55cec15ef7283724fdf7a1af8"
    sha256 cellar: :any_skip_relocation, monterey:       "0956c519da951813c89276e56e3ebda3288e63f7eb859078f2c62aed58edaf8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2dba6b4058d9663afb3d82fcdd7c39144f7137ed20ca72b5260ad6c8d16f685"
    sha256 cellar: :any_skip_relocation, catalina:       "12d87066db1d518023a109dbf3047a690103a126d2dea9e7522e3754cefbfbfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b55f0d10c698f3ff496ca82665eec3f104d6975648158224fb3fe6cadf5ed4"
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
