class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.4/hfst-ospell-0.5.4.tar.bz2"
  sha256 "ab644c802f813a06a406656c3a873d31f6a999e13cafc9df68b03e76714eae0e"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5088d0c6429873262ec79577c701699532cd99c1bf77455a7ab63be572d0a787"
    sha256 cellar: :any,                 arm64_sonoma:  "b2cac7b26219df1c209b6835eb7abff43cdc9ecd766355a334d5a6e7c79b731e"
    sha256 cellar: :any,                 arm64_ventura: "c64c20fadfed9935cb46d863b734d8e0298d12e28ba0aed28d187232fe9dfcd5"
    sha256 cellar: :any,                 sonoma:        "dddc494496217b19c302f5fc906c024a712db29339572df6f5636c7ea389e29b"
    sha256 cellar: :any,                 ventura:       "52dac24f4d57082868ea44dc3f5c9783a9bffe84bf03104f7f739fb3551e6292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "544f9983ad1876b2b7c6be80d6eea1d0f8ca74dc5995544d1ac1d2da0d865d8c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"
  depends_on "libarchive"

  def install
    ENV.cxx11

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"hfst-ospell", "--version"
  end
end
