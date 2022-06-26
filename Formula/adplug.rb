class Adplug < Formula
  desc "Free, hardware independent AdLib sound player library"
  homepage "https://adplug.github.io"
  url "https://github.com/adplug/adplug/releases/download/adplug-2.3.3/adplug-2.3.3.tar.bz2"
  sha256 "a0f3c1b18fb49dea7ac3e8f820e091a663afa5410d3443612bf416cff29fa928"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0ec6a15a91e9fd25a3ccb7cd84b17c7e2ef5c7c1d7d942332de2489ea28dc86f"
    sha256 cellar: :any,                 arm64_big_sur:  "4b28021b120d5e58c7227934d09744833b0406fdd02107c8032f112e4cf4f520"
    sha256 cellar: :any,                 monterey:       "690c9c37d9fc89f2a85d98f41af9e28e4ca24c618390d1d9120f88882f36f19f"
    sha256 cellar: :any,                 big_sur:        "a26ee4d452a1ac114bd4ed0b208741f5282fccbcb9a1f82f0b3f8aa309e18fcf"
    sha256 cellar: :any,                 catalina:       "1698e0290de585761d85501881c22826662a4e1a04d5818a1a45d00a98f306ef"
    sha256 cellar: :any,                 mojave:         "9dc95d2cd84290b55285581c4214234afe13c009be2a67f3ceeb5de39ffe0729"
    sha256 cellar: :any,                 high_sierra:    "d9be8ef57f38e700c36e0f00563f5d31256112e1d2a870a97c3ac4d75ae138f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dd7290f9bbac079019cee98d1e303f863db604c58c6b942ed8dfd4df364c88f"
  end

  depends_on "pkg-config" => :build
  depends_on "libbinio"

  uses_from_macos "texinfo" => :build

  resource "ksms" do
    url "http://advsys.net/ken/ksmsongs.zip"
    sha256 "2af9bfc390f545bc7f51b834e46eb0b989833b11058e812200d485a5591c5877"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("ksms").stage do
      mkdir "#{testpath}/.adplug"
      system "#{bin}/adplugdb", "-v", "add", "JAZZSONG.KSM"
    end
  end
end
