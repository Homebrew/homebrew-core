class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v1.0.4.tar.gz"
  sha256 "a4bd5f70a199b844a34a3b4c4677ea56780c055db7c557ff5bd8f2772378a4d6"
  revision 1
  version_scheme 1

  bottle do
    sha256 "d736fdabb393e90e6895b9d5694cc0a78f592bd363483e7e935d044fd0331d41" => :mojave
    sha256 "f6b5f606925ac38d24ef56fc52e93c3f5a4e8f1ab2d687ebb376c78d4f91f366" => :high_sierra
    sha256 "66d81a3bf524ab635a34803119837ef26704011b2d362ab7f41aba0d40b54ea3" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    # Global config overrides local config, so delete global config to prioritize the
    # config in $HOME/.config/apt-dater
    (prefix/"etc").rmtree
  end

  test do
    system "#{bin}/apt-dater", "-v"
  end
end
