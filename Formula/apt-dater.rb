class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v1.0.4.tar.gz"
  sha256 "a4bd5f70a199b844a34a3b4c4677ea56780c055db7c557ff5bd8f2772378a4d6"
  version_scheme 1

  bottle do
    sha256 "4f78cd39056de845ee6d6b98ecb5f2466cb6b143a862caa9d31612058e4ad15b" => :mojave
    sha256 "4f93025106f9d8d800a2b894a3a8c06146838396d3059f345ee07a75b966ca78" => :high_sierra
    sha256 "86cd9b4621f247fa65ccc760f9090e997450d9ad618c5140a9abf4eb0f8e1c6b" => :sierra
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
    system "make", "AM_LDFLAGS=", "install"
  end

  test do
    system "#{bin}/apt-dater", "-v"
  end
end
