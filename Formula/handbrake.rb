class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.2.2/HandBrake-1.2.2-source.tar.bz2"
  sha256 "df6816f517d60ae8a6626aa731821af2d1966c155fa53b2b9a06c47f3c565e4c"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d355b648d84c7438e4abc411e491c3a49a0558f24fa16f8f9fa48822c75bc242" => :catalina
    sha256 "62a2eb518d2058921f467312c37214a6b9cabd0e5d7e0efe95015a5dd38c9425" => :mojave
    sha256 "c5b58b1d1cd02b23975833e737ec09568e9f36e622e7137aa6c0939ef764b03e" => :high_sierra
    sha256 "0f92e1d55b7d537313e3c2b01e7a780c58956f044a3f3968f84a13ae00050dd9" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "yasm" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
