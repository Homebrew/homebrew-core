class EotUtils < Formula
  desc "Tools to convert fonts from OTF/TTF to EOT format"
  homepage "https://www.w3.org/Tools/eot-utils/"
  url "https://www.w3.org/Tools/eot-utils/eot-utilities-1.1.tar.gz"
  sha256 "4eed49dac7052e4147deaddbe025c7dfb404fc847d9fe71e1c42eba5620e6431"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?eot-utilities[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cac289120cb93a9612419cd0108051fff840e4136011a31c44a2dbee6e31214"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f017607b1caeb3d53e2054abe9b3a75cd8a513b3ef5874b297f7b076ecd5c9a"
    sha256 cellar: :any_skip_relocation, monterey:       "eb728a14df732af84e10461a75b4c56ac083ae4f84d2473219a04021abf678be"
    sha256 cellar: :any_skip_relocation, big_sur:        "146f315f88dffb59c62cd7cec217851ecf5586c42e6317a453b3a635391eab28"
    sha256 cellar: :any_skip_relocation, catalina:       "8d2e463b47a858921b972403f2aa79c6fe80318973fbe5e3f272dc0e1b6dc5b0"
    sha256 cellar: :any_skip_relocation, mojave:         "9e3a062c4d2e5345703442a1428f51bcc1554d07a94f6e540d8a631c2ba2633d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "56f30e1b637149b8b34d003ff4c43865175950eb25d528e0cda69dd4e9261b06"
    sha256 cellar: :any_skip_relocation, sierra:         "320909b9801c96b10491dca13de7c793dae8b0d0864839c6b7a65cbaa1e8e036"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b2a4e0f385fa861baf54ac3c483f5599bc96994b3797fe00430653f1a5c28ba4"
    sha256 cellar: :any_skip_relocation, yosemite:       "3276e755d84fda54851733b693e56922ddb597f1ac4f14792f4221ce794832da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48cf7e721c0bd57766f90fa9cde2704d44e997016d814994b2df85d345b90f8d"
  end

  resource "eot" do
    url "https://github.com/RoelN/font-face-render-check/raw/98f0adda9cfe44fe97f6d538aa893a37905a7add/dev/pixelambacht-dash.eot"
    sha256 "23d6fbe778abe8fe51cfc5ea22f8e061b4c8d32b096ef4a252ba6f2f00406c91"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("eot").stage do
      system "#{bin}/eotinfo", "pixelambacht-dash.eot"
    end
  end
end
