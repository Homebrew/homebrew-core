class BdcCli < Formula
  desc "A tool between developers and complex backend infrastructure"
  homepage "https://github.com/sysintelligent/bdc-bridge"
  url "https://github.com/sysintelligent/bdc-bridge/archive/v1.0.1.tar.gz"
  sha256 "0a39ab5a0cbdf83c9a2744575e53174a1f6b5bfcf571e05b3ede2d11692831d4"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bdc-cli", "./cmd/bdc-cli"
    bin.install "bdc-cli"
  end

  test do
    system "#{bin}/bdc-cli", "version"
  end
end 