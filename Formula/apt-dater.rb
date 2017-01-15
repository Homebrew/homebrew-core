class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v1.0.3.tar.gz"
  sha256 "891b15e4dd37c7b35540811bbe444e5f2a8d79b1c04644730b99069eabf1e10f"

  bottle do
    sha256 "e8c3997c31dd62b04f5da31bd2055fea9ebb12e3959d09840d9eac0801e1befc" => :sierra
    sha256 "ac82bb9943120aa1325e782c2ef99cad7a6ecd12f260c0f7f1e054015c7f39bc" => :el_capitan
    sha256 "7d2a6d082f2a2d0271bb7c87f30ddda2a94a51134dc1efa490b6042bfdf21bc4" => :yosemite
    sha256 "43774745944523bb099fad706d8bc8ac81ec0716ca1c41c2cacb1352a9902e90" => :mavericks
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
