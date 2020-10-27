class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/developer/get-started/ioctl-install.html"
  url "https://github.com/iotexproject/iotex-core/archive/v1.1.2.tar.gz"
  sha256 "d35015f71fb5da78280e61c9836e877fb903452c58053601892d40260cb571db"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4029bdda7e6e971d514fdd1090797f9935183b27af0c5e3430a590adb2529ef" => :catalina
    sha256 "af246fb4e7a0b9ddab788b50a78afcefae0c6071f83c1d65bdff0d26054d5b82" => :mojave
    sha256 "2353cb2f9fe538c2157109894ba68da42c586d2a2b378f7b34398dd89b4d4f98" => :high_sierra
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
