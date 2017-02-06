class EmsFlasher < Formula
  desc "Software for flashing the EMS Gameboy USB cart"
  homepage "https://lacklustre.net/projects/ems-flasher/"
  url "https://lacklustre.net/projects/ems-flasher/ems-flasher-0.03.tgz"
  sha256 "d77723a3956e00a9b8af9a3545ed2c55cd2653d65137e91b38523f7805316786"
  head "git://lacklustre.net/ems-flasher"

  bottle do
    cellar :any
    sha256 "3e48e32d5c881d2c4f5f6bd8d5f454f22d7f174da04a62ba141cc4f5403b9cf5" => :yosemite
    sha256 "a8eb1537eab2d24537afbf4ab3f27e0514214f84fabdb77415c096bd04147318" => :mavericks
    sha256 "a4bc387b199cb3842d4dee3998c24b1b73a30e9868fd9f9c1ce3f7ecbf5c0117" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make"
    bin.install "ems-flasher"
  end

  test do
    system "#{bin}/ems-flasher", "--version"
  end
end
