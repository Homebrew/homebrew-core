class Avce00 < Formula
  desc "Make Arc/Info (binary) Vector Coverages appear as E00"
  homepage "http://avce00.maptools.org/avce00/index.html"
  url "http://avce00.maptools.org/dl/avce00-2.0.0.tar.gz"
  sha256 "c0851f86b4cd414d6150a04820491024fb6248b52ca5c7bd1ca3d2a0f9946a40"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?avce00[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9078894641a0060c43d87875285e11baab6f2a7f24c36f109f56687b2eaf5674"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d68b4c2b28928e6f435666ae990ecc9f6ad4b082158374c24437c7d18d6a84f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c4e10ddc6cad4b6a7001a697b8318513a09166e70fa6831ed5fdbede1e71d47"
    sha256 cellar: :any_skip_relocation, ventura:        "eb6894812ee0f45a4922522cc2c8a38c6f023dc49be73b70209908be6c373ea3"
    sha256 cellar: :any_skip_relocation, monterey:       "eea33df8503aff86d07c0e10947fa54e57c579755086838aca78da96b00d4dce"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fdd45d6a401ca88019bbd58cb3afdda23dedf706c4556e87a7cc48b1a3e952a"
    sha256 cellar: :any_skip_relocation, catalina:       "db71ee14a03d041413530c0974ce7703100dc3259fc0d2ea5a32fadcf7180133"
    sha256 cellar: :any_skip_relocation, mojave:         "285b4eb74ff189689097df36f62fa4c2a48b68ece7442156a5700b6c36feb743"
    sha256 cellar: :any_skip_relocation, high_sierra:    "40b26638adfaf290bc07ae792da49106b493ea3109a97c1fac775723a0463ac4"
    sha256 cellar: :any_skip_relocation, sierra:         "576b5ea62376b42733d56e7bd862522588c16160ac1abb5f382c1c12055248e1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "45f18e289431af4de0d1e96c1fadd6a056e80907a1650654f8ee0dd1dafab401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac93d6ed79eb10699125a47c23e8ece19290f75bd186a670dc25396ef32b1f86"
  end

  conflicts_with "gdal", because: "both install a cpl_conv.h header"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "avcimport", "avcexport", "avcdelete", "avctest"
    lib.install "avc.a"
    include.install Dir["*.h"]
  end

  test do
    touch testpath/"test"
    system "#{bin}/avctest", "-b", "test"
  end
end
