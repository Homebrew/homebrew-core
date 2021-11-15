class Mkvdts2ac3 < Formula
  desc "Convert DTS audio to AC3 within a matroska file"
  homepage "https://github.com/JakeWharton/mkvdts2ac3"
  license "Apache-2.0"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "19928b2ef2664b358d7dca5fd53a9098c260eed4c61d37227097981e619af504"
    sha256 cellar: :any_skip_relocation, big_sur:       "d146252c7f8a7e75a78bdde799e88156851d16974ae35c2e54397c7c3dc93d7c"
    sha256 cellar: :any_skip_relocation, catalina:      "76873d06126eddea9f43414bbaa9b35d2aa50e9f17f3ab0a490d733c6cf71438"
    sha256 cellar: :any_skip_relocation, mojave:        "932762d9435e3ddd0fff7a1ead1e0c906bc505517545f0c10f877cd61dd77365"
    sha256 cellar: :any_skip_relocation, high_sierra:   "54e70bb92dfdfe615346d6ba815648b1714da8b08a2f361fa95d104f14cee367"
    sha256 cellar: :any_skip_relocation, sierra:        "9a501348303556d867917f03c9c456216d1de39a19e5978472e2ef57f7d6731f"
    sha256 cellar: :any_skip_relocation, el_capitan:    "d3eaf28d8c9718a73c2309eb8d9fc7c0a8db2ea6517324a80092ca02ac7842d4"
    sha256 cellar: :any_skip_relocation, yosemite:      "4b4c9bf979e7ecd9efa254a9e5fdfe13a5549a209958f86e1233b8cc87a38e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "471db2824e25cbbdc46fb1e42b2d8fc1c24ba4e92df73cd509b8036f1f559746"
    sha256 cellar: :any_skip_relocation, all:           "471db2824e25cbbdc46fb1e42b2d8fc1c24ba4e92df73cd509b8036f1f559746"
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
