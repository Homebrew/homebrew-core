class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.4.5.tar.gz"
  sha256 "9a6aa00f7402320deb982105f826da50391d9c55960431244825cae24a45714f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4719e9a51b565f5d93ca2ab4577f63b5122e7b9c09c8d481a264bc7579bd7604" => :catalina
    sha256 "23cc4b3bfcf64e7f708f7ccb1dceb35cccd55b7723ff76e5a045cb007e007473" => :mojave
    sha256 "dca800c6f59a49cc95ff858819fad6617530399099957e7306d56212b7f73364" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"cointop"
    prefix.install_metafiles
  end

  test do
    system bin/"cointop", "test"
  end
end
