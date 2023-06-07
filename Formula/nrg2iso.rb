class Nrg2iso < Formula
  desc "Extract ISO9660 data from Nero nrg files"
  homepage "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html"
  url "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso-0.4.1.tar.gz"
  sha256 "3be36a416758fc1910473b49a8dadf2a2aa3d51f1976197336bc174bc1e306e5"
  license "GPL-3.0-or-later"

  # The latest version reported on the English page (nrg2iso.en.html) and the
  # main French page (nrg2iso.html) can differ, so we may want to keep an eye
  # on this to make sure we don't miss any versions.
  livecheck do
    url :homepage
    regex(/href=.*?nrg2iso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f68337a5c1aef14aff2ae516a4a87c1e51c886c1485c6a8b5e5abf5a0253f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f66686ff7f33af0e071175ff79b600cd843a1e8daeb94af0785844a56528a9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca8279b0cbdf542068fad1c72abbd63dab1c756a315e676a0e704d19196feeb9"
    sha256 cellar: :any_skip_relocation, ventura:        "b58424cd717ffc269c6a5208922f5a91375040c4e2d2a53e280645d0547a3e71"
    sha256 cellar: :any_skip_relocation, monterey:       "1de954133ee56482c496ff5fa1d688048a3487a08aee8c4c9a47b733631a135a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad5cff7cbfe394a08dbe9f52f0f0d7872be02fde704cd610bb2cafba844fae6"
    sha256 cellar: :any_skip_relocation, catalina:       "4928245286399a545930ec079d6299a844e334e5cbe90eab8d8e55f0fc690f66"
    sha256 cellar: :any_skip_relocation, mojave:         "3d965e8881897c8c2b42acc476b066398eeb074acce577f011c850c0ee7b5eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "740b102a8a4df8a8523a8b7812e3eed07f9ce6e0e1c8557867360fe4c1a18136"
  end

  def install
    # fix version output issue
    inreplace "nrg2iso.c", "VERSION \"0.4\"", "VERSION \"#{version}\""

    system "make"
    bin.install "nrg2iso"
  end

  test do
    assert_equal "nrg2iso v#{version}",
      shell_output("#{bin}/nrg2iso --version").chomp
  end
end
