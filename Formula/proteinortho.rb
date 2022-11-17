class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.3/proteinortho-v6.1.3.tar.gz"
  sha256 "ee58364041b3449477c009ff607266303db85f5bc7959fea4c2a3bc4f0667e33"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "367ededcf3fa24fd57af72057d5558093f0f5cd7b25aef2431c268efc9250903"
    sha256 cellar: :any,                 arm64_monterey: "e37cd3ee8bf11b8a8506272777f1171c91cfda7ce05ad6372c7e420a5ecb7485"
    sha256 cellar: :any,                 arm64_big_sur:  "51e2136ac2273b2ef5291bf33d5a20ef7a1ab8a19c9a7c5d18deef0542672318"
    sha256 cellar: :any,                 monterey:       "bc5ddd994a419b98bb2ef9186c4e7fe40f63284d98d9fd316bd548e88c37d43a"
    sha256 cellar: :any,                 big_sur:        "1ee18b543cc298f0a92183d08574c7574f9a245874fd6e9961f85d1290163c7a"
    sha256 cellar: :any,                 catalina:       "95047d368966ee67037fa8d06ba23fb01596fce696a7efd2d0f31543dcfc333e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9e82ac86247953c80739fa6647618183e7e2eb324dc4fa56dcf8abf0f20fa6"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
