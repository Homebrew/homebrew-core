class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.47.2.tar.gz"
  sha256 "2205b86f68e054dbe61806f288d94207eddadef7f71a0a27c553db0fc5bd27bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3773d81ea1fa1c0362d43fd05ba34297f668444133ac65c12f952e357b87bde" => :catalina
    sha256 "15b060ac0d5450d4f0c834de332891e9766f713e684992ddaafcd285682a21ec" => :mojave
    sha256 "bd9cd04f9e0cd09e7068fdb5e556ee299549ca554640a2de3c79e74b9cd48fc4" => :high_sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
