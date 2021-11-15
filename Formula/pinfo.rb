class Pinfo < Formula
  desc "User-friendly, console-based viewer for Info documents"
  homepage "https://packages.debian.org/sid/pinfo"
  url "https://github.com/baszoetekouw/pinfo/archive/v0.6.13.tar.gz"
  sha256 "9dc5e848a7a86cb665a885bc5f0fdf6d09ad60e814d75e78019ae3accb42c217"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 arm64_monterey: "64b61bdd18dca5533f6bee2239e0c0eb8740b324697c58e03249c840b66d87d9"
    sha256 arm64_big_sur:  "2592140c0bf2f8e5889f3e2020e163d097b6256bde001139dd88b778f7a985a6"
    sha256 monterey:       "46b86e8f4ff8565977416468316300d749bc65850d5c6fb6afc4b5d8cbcf9162"
    sha256 big_sur:        "9d4ae5da430d85f09f2ef7a2b5292976c3db781f80fd1b249e9d0caa05f74c4e"
    sha256 catalina:       "a41b568910292b2119d0f63f53d5015d781b03576a58f08d397535560d407bf5"
    sha256 mojave:         "b81b1202add75d938802681618f5bf95dd245e03ff80f5f0ca67a5ba8b7bfb84"
    sha256 high_sierra:    "84edf6ec00f570004abc6f3d0335196b513a4a52e589919ca1e70c35b31525cc"
    sha256 sierra:         "9b8e3d359081d68626f86cab8b048926b6471f8ca1be8e47ca8625e22da5021f"
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
