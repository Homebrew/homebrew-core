class Epsilon < Formula
  desc "Powerful wavelet image compressor"
  homepage "https://epsilon-project.sourceforge.io"
  url "https://downloads.sourceforge.net/project/epsilon-project/epsilon/0.9.2/epsilon-0.9.2.tar.gz"
  sha256 "5421a15969d4d7af0ac0a11d519ba8d1d2147dc28d8c062bf0c52f3a0d4c54c4"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/epsilon[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "86724d0787346a00a324bc0204d7b141b43cee6969069351747626354f80507d" => :big_sur
    sha256 "38532cb4e33c6bb1da6f76c3e218c141ccf6888a56200807d05358d64a6709c7" => :arm64_big_sur
    sha256 "62d1ce5e34b79a09f68f079ec79768e85677ab5d6f3c13caedae9bd41399e052" => :catalina
    sha256 "102517b4fb6cb9eccc86a50b774424748805bf14f2d2cc53f08e558f43c3f602" => :mojave
    sha256 "87935305d8659e6cdcde272d469768c48dd870f227ab894aa71a6b206be5fa1f" => :high_sierra
    sha256 "a8aee2fb802a82cdbf701003195285f20f1b067ceec72d6e3170e3a69032a0e8" => :sierra
    sha256 "10da057d558d4d9df8c503135b53f7c23778258f7c66d3b39229bf70d9a887f1" => :el_capitan
    sha256 "2811209670e68ab4316e6d177bc1376cb28462cad9b696b4a782deff4074a9ce" => :yosemite
    sha256 "606cb80be8eebf2df61c726ac3e1d91abda3bc49d3c73ca5d07f85b59734069e" => :mavericks
  end

  depends_on "popt"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/epsilon", "--version"
  end
end
