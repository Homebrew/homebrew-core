class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/noir-cr/noir"
  url "https://github.com/noir-cr/noir/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "eb860df7ec689b41285a4b171013f0850e58bc77a5c37d6b1df47193fa9f61c6"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "8b6cffa8eb7609932840524ee351a767a917c83ac4263da9b4b6e09d22c371e4"
    sha256 arm64_ventura:  "e65affc675d485f011f5e7d35598d887e9f879102e95a4d1ccb99aafc362e2dd"
    sha256 arm64_monterey: "091034692e8c329ffb984092fb802161835ed07ed9fd26fa1d39757030b78826"
    sha256 sonoma:         "dc1036de2801faa6296d24b4247662b82663ff8269adc60663188029217d2e33"
    sha256 ventura:        "49567d5363dd2772063c3802b92907c1d334a29c9713bb6cad2c019e68753bef"
    sha256 monterey:       "872eb1a697a9846c8cc79feaa0f51422a9a674d9861c835ca97d42f5aa836fd5"
    sha256 x86_64_linux:   "7d66854c96d468573b4badc1247ded7f66c9c607489ffc23f8f5453458d36c49"
  end

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/noir-cr/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
