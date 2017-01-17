class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v1.0.3.tar.gz"
  sha256 "891b15e4dd37c7b35540811bbe444e5f2a8d79b1c04644730b99069eabf1e10f"

  bottle do
    sha256 "e4062b5a3202e29cd57cf95328348c20022857ec4486056dcc8bf9c10da5e97a" => :sierra
    sha256 "0ecdb3314feb56e4ca56028317fec6e513223356fb10569bcc86d95db1be19bc" => :el_capitan
    sha256 "daefda2c8bd5c4aae56f69c540905ca08101339b393ea01d697abb05af2d51e0" => :yosemite
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
