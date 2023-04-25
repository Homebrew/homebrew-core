class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/9.0.0.tar.gz"
  sha256 "98cdb137ea96acfcc4739718d9abedc9982a01b367e921cefae8516271d9739e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96b2e4125431fa71e008bc43d370d51fc51d3c2b6a80cd472f17943d2d200ab8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10e4d264840f439eddce66479b7e099d1980e41edfc4b6f7f1182b670742bb76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c35ac1ee2fe4008570a80c8423a154f2a61849d336f139941a13df75be9bb1a7"
    sha256 cellar: :any_skip_relocation, ventura:        "68c6287585b115f52826b576f6934b1d436afdc125dd576c223932e2bdfecf45"
    sha256 cellar: :any_skip_relocation, monterey:       "5bebd8fd71b41e19fa550fbfff028b79387f95457a0abefe35eb7e04e8c06635"
    sha256 cellar: :any_skip_relocation, big_sur:        "5017da137332c1d485437a7f1256e3c3e13a1ee266735eeee43288db3d6f74e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fcc7a3fe3746ff274ff41d6b5ea4d0bb20fd0ee750fdc118108796706488267"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
