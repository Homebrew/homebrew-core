class Dcadec < Formula
  desc "DTS Coherent Acoustics decoder with support for HD extensions"
  homepage "https://github.com/foo86/dcadec"
  url "https://github.com/foo86/dcadec.git",
      tag:      "v0.2.0",
      revision: "0e074384c9569e921f8facfe3863912cdb400596"
  license "LGPL-2.1"
  head "https://github.com/foo86/dcadec.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d458c3484034748b9b1fee9074d5f3018354447d11914f132c6e41899de17491"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "359384000edd00fc8e030bb59f9ebc15a301eb250351a20f2da062cc202caa54"
    sha256 cellar: :any_skip_relocation, monterey:       "702e3f8b57be59604d5969be08fb64067763e5aac353154b233ad74a3f5a3276"
    sha256 cellar: :any_skip_relocation, big_sur:        "2679a012566efff2d1ad05021648975dc2960d2ff42720d53b001631311d4a51"
    sha256 cellar: :any_skip_relocation, catalina:       "0622b87f5b7f7c71346443f12d5e3d6eabd02aa63dce433c7248d405a9fbc036"
    sha256 cellar: :any_skip_relocation, mojave:         "68b350a3ec6a1ab7384eac3341a03762e8233dec742c35f8dc2afc213b3db567"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7f938bcd68b9078df3dc6e67d82e08beb55b10228a808d91543a6ed2d15a2002"
    sha256 cellar: :any_skip_relocation, sierra:         "7a51fb1bfa07f08c45176df419087429e9ffce945cbcd28d71e403c456762c74"
    sha256 cellar: :any_skip_relocation, el_capitan:     "89ddc5e9a5cfd72e604bdff54ee1f09f9ad4ec281fc79c93201971bbd380ccdd"
    sha256 cellar: :any_skip_relocation, yosemite:       "640914a5ce466bbb91b551bdb35a385e4a8b08c25f78509a16c016c654963805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f727365cbd24d678682c06e73ff49a7fdf92b17a5a1c6b82068522e4d0e0b1f"
  end

  resource "sample" do
    url "https://github.com/foo86/dcadec-samples/raw/fa7dcf8c98c6d/xll_71_24_96_768.dtshd"
    sha256 "d2911b34183f7379359cf914ee93228796894e0b0f0055e6ee5baefa4fd6a923"
  end

  def install
    system "make", "all"
    system "make", "check"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    resource("sample").stage do
      system "#{bin}/dcadec", resource("sample").cached_download
    end
  end
end
