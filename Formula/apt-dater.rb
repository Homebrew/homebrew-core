class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v1.0.3.tar.gz"
  sha256 "891b15e4dd37c7b35540811bbe444e5f2a8d79b1c04644730b99069eabf1e10f"
  version_scheme 1

  bottle do
    rebuild 2
    sha256 "026b29a9428c2c1d77e70001c8651f8e8ac20b20dee1ba62a89e0d69e2da570e" => :sierra
    sha256 "a2f37094132e6f5cd8ad9b287bf299eea8acbc99b1d468002dfe875a8a14985d" => :el_capitan
    sha256 "2ac3ba56f32d018a9af477484d8ad561871f855aca78726dbe8f43f5552f6acc" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "AM_LDFLAGS=", "install"
  end

  test do
    system "#{bin}/apt-dater", "-v"
  end
end
