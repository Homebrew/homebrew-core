class Mkvdts2ac3 < Formula
  desc "Convert DTS audio to AC3 within a matroska file"
  homepage "https://github.com/JakeWharton/mkvdts2ac3"
  revision 3
  head "https://github.com/JakeWharton/mkvdts2ac3.git"

  stable do
    url "https://github.com/JakeWharton/mkvdts2ac3/archive/1.6.0.tar.gz"
    sha256 "f9f070c00648c1ea062ac772b160c61d1b222ad2b7d30574145bf230e9288982"

    # patch with upstream fix for newer mkvtoolnix compatibility
    # https://github.com/JakeWharton/mkvdts2ac3/commit/f5008860e7ec2cbd950a0628c979f06387bf76d0
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/mkvdts2ac3/1.6.0.patch"
      sha256 "208393d170387092cb953b6cd32e8c0201ba73560e25ed4930e4e2af6f72e4d9"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "76873d06126eddea9f43414bbaa9b35d2aa50e9f17f3ab0a490d733c6cf71438" => :catalina
    sha256 "932762d9435e3ddd0fff7a1ead1e0c906bc505517545f0c10f877cd61dd77365" => :mojave
    sha256 "54e70bb92dfdfe615346d6ba815648b1714da8b08a2f361fa95d104f14cee367" => :high_sierra
    sha256 "9a501348303556d867917f03c9c456216d1de39a19e5978472e2ef57f7d6731f" => :sierra
    sha256 "d3eaf28d8c9718a73c2309eb8d9fc7c0a8db2ea6517324a80092ca02ac7842d4" => :el_capitan
    sha256 "4b4c9bf979e7ecd9efa254a9e5fdfe13a5549a209958f86e1233b8cc87a38e4b" => :yosemite
    sha256 "336cc7357b741d3e045a2c9a32f19f8daba41cfd3d00d2d3422d7b31c91ad538" => :mavericks
  end

  depends_on "ffmpeg"
  depends_on "mkvtoolnix"

  def install
    bin.install "mkvdts2ac3.sh" => "mkvdts2ac3"
  end

  test do
    system "#{bin}/mkvdts2ac3", "--version"
  end
end
