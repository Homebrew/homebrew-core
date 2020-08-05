class Pinfo < Formula
  desc "User-friendly, console-based viewer for Info documents"
  homepage "https://packages.debian.org/sid/pinfo"
  url "https://github.com/baszoetekouw/pinfo/archive/v0.6.13.tar.gz"
  sha256 "9dc5e848a7a86cb665a885bc5f0fdf6d09ad60e814d75e78019ae3accb42c217"
  revision 1

  bottle do
    sha256 "a41b568910292b2119d0f63f53d5015d781b03576a58f08d397535560d407bf5" => :catalina
    sha256 "b81b1202add75d938802681618f5bf95dd245e03ff80f5f0ca67a5ba8b7bfb84" => :mojave
    sha256 "84edf6ec00f570004abc6f3d0335196b513a4a52e589919ca1e70c35b31525cc" => :high_sierra
    sha256 "9b8e3d359081d68626f86cab8b048926b6471f8ca1be8e47ca8625e22da5021f" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pinfo", "-h"
  end
end
