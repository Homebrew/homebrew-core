class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.4/hfst-ospell-0.5.4.tar.bz2"
  sha256 "ab644c802f813a06a406656c3a873d31f6a999e13cafc9df68b03e76714eae0e"
  license "Apache-2.0"
  revision 5

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd84297fca2dd33dcec237d5d54d0e45f52fcaf64e8d6e6b27695a7e0558825c"
    sha256 cellar: :any,                 arm64_sequoia: "9f7a74646d284084392b523263f4e769dcd62d5433c3d40b1eb0da872c55ab6a"
    sha256 cellar: :any,                 arm64_sonoma:  "915fcf467c2a1333cc3c73ec013fac25cf14bdeb4d40777cdb70bd48fca25a63"
    sha256 cellar: :any,                 sonoma:        "d5530f8b220068236908e9776a9535978878e230067c4fe7f8bc30d633cf99d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8776bf8a9d43167fb8a09581a8b0870b2d7b3ac2061eba88d004c65274dfcb2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e6440c7359b04a940556dfe100c181600a5832b01fed8c00c54693b5bc9c35"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "libarchive"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", "--without-libxmlpp", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"hfst-ospell", "--version"
  end
end
