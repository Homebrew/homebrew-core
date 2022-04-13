class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.34/proteinortho-v6.0.34.tar.gz"
  sha256 "2559eee1967d066afbb3fb182e386761360eaac644b0f56986216b75eb3fcef1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "86d0a6bba939c19be78b655b7fe161e7c2aa51d5535db2b8918def494b70d6ee"
    sha256 cellar: :any,                 arm64_big_sur:  "ae9faec3141c8ad3f91975208cfe2788bc83d3c80d33171269cb88495f6d457a"
    sha256 cellar: :any,                 monterey:       "63d12ed4d29984b6bed15047c392fc7e2dad45df827a5631b0cd183725df092c"
    sha256 cellar: :any,                 big_sur:        "8eef61bed20ff2035788c88088d4e15d3bc6e4f93526de5b4d3df8420a8a2d61"
    sha256 cellar: :any,                 catalina:       "ab9b48a0acf47a57d7f5d92d1181d67a87b3fb57d5132900d45d666bfff570ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc69849d15f173ed8145690fe9b1d525c20cbbcbb9d8e3c6110a689f3eaa5fea"
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
