class Aalib < Formula
  desc "Portable ASCII art graphics library"
  homepage "https://aa-project.sourceforge.io/aalib/"
  url "https://downloads.sourceforge.net/project/aa-project/aa-lib/1.4rc5/aalib-1.4rc5.tar.gz"
  sha256 "fbddda9230cf6ee2a4f5706b4b11e2190ae45f5eda1f0409dc4f99b35e0a70ee"
  license "GPL-2.0-or-later"
  revision 2

  # The latest version in the formula is a release candidate, so we have to
  # allow matching of unstable versions.
  livecheck do
    url :stable
    regex(%r{url=.*?/aalib[._-]v?(\d+(?:\.\d+)+.*?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "031eac9658cb6878fea6b53e232e0b3f294b81953dd1803bd808c26c5b1a934a"
    sha256 cellar: :any_skip_relocation, big_sur:       "fb1df93a418c2ae4b7c358d19b58afc0ad73d9d1e6f22b92aa5d5f086cb48a70"
    sha256 cellar: :any_skip_relocation, catalina:      "d83c1b827ca16ae5450356db32fe1b27e910a27bbe2b074a9b4c22fe310bc5b7"
    sha256 cellar: :any_skip_relocation, mojave:        "46feeea3fc331a6982fa1960645e1851d3f395f36fbd99cbf92a7406030d9511"
  end

  # Fix malloc/stdlib issue on macOS
  # Fix underquoted definition of AM_PATH_AALIB in aalib.m4
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6e23dfb/aalib/1.4rc5.patch"
    sha256 "54aeff2adaea53902afc2660afb9534675b3ea522c767cbc24a5281080457b2c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-shared=yes",
                          "--enable-static=yes",
                          "--without-x"
    system "make", "install"
  end

  test do
    system "script", "-q", "/dev/null", bin/"aainfo"
  end
end
