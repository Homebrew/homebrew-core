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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "64e5e47e5219e1d27e3683f4c4d174c5cb79117aa6cbf99e1a6939530a359143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dcf1a3953bd2c4baedc5f004a95be4704f19c554d064c27e613a2384edbffd82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50db80cb120e30adb337ad7c89a227bc3a2d324f7f86415688704f67fd7afbe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f0213f9bcedaf984fcd8d2d03894e8a19e1a61c58775efe87d557946dfea9b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cac289120cb93a9612419cd0108051fff840e4136011a31c44a2dbee6e31214"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f017607b1caeb3d53e2054abe9b3a75cd8a513b3ef5874b297f7b076ecd5c9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa9707f3206765baa965478369db3855b6f42b4f3ca5fd9274ac47dfa6aef9e4"
    sha256 cellar: :any_skip_relocation, ventura:        "1a0d54258d1c6df0ded3e820520cf809bc1ffd0c6fb5b9c1236aead95c8f69d1"
    sha256 cellar: :any_skip_relocation, monterey:       "eb728a14df732af84e10461a75b4c56ac083ae4f84d2473219a04021abf678be"
    sha256 cellar: :any_skip_relocation, big_sur:        "146f315f88dffb59c62cd7cec217851ecf5586c42e6317a453b3a635391eab28"
    sha256 cellar: :any_skip_relocation, catalina:       "8d2e463b47a858921b972403f2aa79c6fe80318973fbe5e3f272dc0e1b6dc5b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8fb16ef58c49f4b1b9029ca5994093ed3305976d8a7f7f5077413135515b3c66"
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
      system bin/"eotinfo", "pixelambacht-dash.eot"
    end
  end
end
