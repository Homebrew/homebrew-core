class Mon < Formula
  desc "Monitor hosts/services/whatever and alert about problems"
  homepage "https://github.com/tj/mon"
  url "https://github.com/tj/mon/archive/refs/tags/1.2.3.tar.gz"
  sha256 "978711a1d37ede3fc5a05c778a2365ee234b196a44b6c0c69078a6c459e686ac"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1113e36de927c4dfbb16bcb801d77fd6a1508104c9de9a5f885c768514fb1d3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8be88943149d839ef8ffc37b1b81150f8c0325fc40a1878bd864df744fa96d67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6e93600a34a633e6d90e5096c5e13e6df1080197f84ffcb1ad4fab2cafa9a04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51930349a969998d73df25075032c233871f445a9e7419f90419103c223110f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f814c697e985f27214f721e5205baa19e3673f94b905975f2cf65bf8e47bd07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65f144b16a687002f9d30ac665886aa8b06bb914e4ff0fe04e692a6a153eb76b"
    sha256 cellar: :any_skip_relocation, sonoma:         "72f500fe72c9afecadef4ea76245d879a72250264d2c4dc75a0a6e0923391615"
    sha256 cellar: :any_skip_relocation, ventura:        "44084ac7f259335761c5569cb0f59d00df44c39b5fea84d763140c364b3b9459"
    sha256 cellar: :any_skip_relocation, monterey:       "33b0a9658fe9c49984aeb76681165f01f586f25489b389db158bcbaac2a6ae2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6530e73e7a94297f2646a079361df7076cbc6a881b5baf227a703f1edd92cecc"
    sha256 cellar: :any_skip_relocation, catalina:       "becdcce9ec6a3ec5156cf27db02c50c26e99a9db9626c864abf9eb2f178ea57e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "00ecf73b33edac694c7a24207ead5f8604a20b0a97e681685d997d81080f19c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98cf650f601c5c437802ac8a979d24bdd8fe39cef4a3937f440109c91cadd69a"
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"mon", "-V"
  end
end
