class Lbzip2 < Formula
  desc "Parallel bzip2 utility"
  homepage "https://github.com/kjn/lbzip2"
  url "https://web.archive.org/web/20170304050514/archive.lbzip2.org/lbzip2-2.5.tar.bz2"
  mirror "https://fossies.org/linux/privat/lbzip2-2.5.tar.bz2"
  sha256 "eec4ff08376090494fa3710649b73e5412c3687b4b9b758c93f73aa7be27555b"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a41953244b7b781c4620ef0b757648ee8f0cd43ef5d616f44a9f4aebf9a5342a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9815b21683195fdeda12fe2ec7b2f4336d34e7a4b44a4a318c67efed6f9e035e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9ecc58d178f18ab33d500ed768c156058589fed3132bf804314e76715730333"
    sha256 cellar: :any_skip_relocation, ventura:        "494a45ea5c053b6bcf63fada0b93c4400ef887d3016eab7e1cee20dd75054763"
    sha256 cellar: :any_skip_relocation, monterey:       "b9882075d6ce9ed47c0e18cc27c9b23706a8ceedc8ff42977b614f8fc92cdb57"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bb02d26e53336134329f3aaacf2ce045375b926b283520788ecdf2ae4d778e6"
    sha256 cellar: :any_skip_relocation, catalina:       "6643ba1c0f17a13e742383c69112df62c1d6bce80e6833d717df4e112922deb5"
    sha256 cellar: :any_skip_relocation, mojave:         "5f7f053aac95586cdcacb2528fe4540bd16522707e9d7bbbf8e6d38012378e06"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3d4e0de242b81f83ba2addd163688647288fb17f3a3ae3ccd37a2e62f20871d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88137d3cccfc08f362d926aeaad73312aa4d5265dd89fc92c881b1da20097f6f"
  end

  # Fix crash on macOS >= 10.13.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b276429dbe68323349e1eda09b7e5d5a1082671/lbzip2/gnulib-vasnprintf-port-to-macOS-10-13.diff"
    sha256 "5b931e071e511a9c56e529278c249d7b2c82bbc3deda3dd9b739b3bd67d3d969"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    touch "fish"
    system "#{bin}/lbzip2", "fish"
    system "#{bin}/lbunzip2", "fish.bz2"
  end
end
