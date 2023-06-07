class Flac123 < Formula
  desc "Command-line program for playing FLAC audio files"
  homepage "https://flac-tools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flac-tools/flac123/flac123-0.0.12-release.tar.gz"
  sha256 "1976efd54a918eadd3cb10b34c77cee009e21ae56274148afa01edf32654e47d"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7dbcf8228ae81f22b3163fa6ce76d5fc4ac68fe49f19a7921e5e3904bc09c28c"
    sha256 cellar: :any,                 arm64_monterey: "a03e7e7519e8fd6299a6597654a47cee49794cd72e96fce5016172a1dedf9105"
    sha256 cellar: :any,                 arm64_big_sur:  "97ea9fd6161053506401386e9a0b3e81a52e4e8a9d95ffbb4b89cc31cf4c6445"
    sha256 cellar: :any,                 ventura:        "26e03d55d64e8964a0cf83380e1e1dea1cd091fd4c2895dc32e24edf361472b2"
    sha256 cellar: :any,                 monterey:       "f486d727f47c8560903a411ec7959e5b35beaec7e21402ecf034a2c1a7a04c3e"
    sha256 cellar: :any,                 big_sur:        "9e93af1f7c8db883b9e29e054803a6abb3a2e09e20dd062a7dc1dc27eedcc836"
    sha256 cellar: :any,                 catalina:       "740df479667cf418850fd824be8bde16c26b6e14152f1891a7566d65cef4647d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea0d5a9fbd3ee85227c1a0d45d8c80b4c20cece5cf8ae73284150016cbeadd83"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "popt"

  def install
    ENV["ACLOCAL"] = "aclocal"
    ENV["AUTOMAKE"] = "automake"
    system "aclocal"
    system "automake", "--add-missing"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    driver = OS.mac? ? "macosx" : "oss"
    system "#{bin}/flac123", "-d=#{driver}"
  end
end
