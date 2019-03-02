class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v1.0.4.tar.gz"
  sha256 "a4bd5f70a199b844a34a3b4c4677ea56780c055db7c557ff5bd8f2772378a4d6"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 "c0511a22aa94d42d26e1d314e13f87375bf57d4fbe1fb8ca3532ab250e751d4d" => :mojave
    sha256 "b8766c0ad1bf2a0fbb50a9bf062c53aacb98855307732e9df866651f13be3aa9" => :high_sierra
    sha256 "7c90d33ef6d7c577506997b998fa286f9f54fb0acf47a3590e653fcecc840a14" => :sierra
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
