class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "https://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.32.3.tar.bz2"
  sha256 "17abe02d043a253b68b47e3af69c9fc755b895db68fdc8811786125df564c6e0"
  license "GPL-3.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/icoutils/"
    regex(/href=.*?icoutils[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "5721ca4ce6fb6378b9ce79e9f193683e2c5b4aa94d6a015518429f78ca65d295"
    sha256 cellar: :any, arm64_big_sur:  "f761caa78a9a27c9480f9e6e78e44f8fa38e48404c5ee7488eedeb4ea51eb224"
    sha256 cellar: :any, monterey:       "7a359d1dce56f8b319ffd8c56e59edc508d5337885424afc4374eca8f1817e3a"
    sha256 cellar: :any, big_sur:        "9c63325e7eb42817701d615003736bc2aa04656d5b6b56d475712056836dccce"
    sha256 cellar: :any, catalina:       "67e11f8966ff949902c637dccea47ee5ee341128519050f31f6c87eb74264d99"
    sha256 cellar: :any, mojave:         "c22bed7e3ad43221011658fb8acd08481dccd11b0cc5750e6a21502d7da51fb9"
    sha256 cellar: :any, high_sierra:    "50b8adff5f3364626026d19fba9a0c9fef8cf93104b8d6907bcbe8a5f4a136c2"
    sha256 cellar: :any, sierra:         "1a3656f2fcf778aa32eb734a60dfceccd5e1a702fa6558b11b33cc6f44aeba99"
    sha256 cellar: :any, el_capitan:     "fb93eb5cfa6b222e77ec07569f501fcc03143e9decf306ebd21e9d1c6d304bce"
    sha256               x86_64_linux:   "9a725092dcfb0f4eeda7085628686d67c98475bdb81e2b3cdc657f5837040982"
  end

  depends_on "libpng"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"icotool", "-l", test_fixtures("test.ico")
  end
end
