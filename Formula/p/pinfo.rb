class Pinfo < Formula
  desc "User-friendly, console-based viewer for Info documents"
  homepage "https://packages.debian.org/sid/pinfo"
  url "https://github.com/baszoetekouw/pinfo/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "9dc5e848a7a86cb665a885bc5f0fdf6d09ad60e814d75e78019ae3accb42c217"
  license "GPL-2.0-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "667ab0c89a77262f57669ed57148c06df889bdc835231752a1dd4fd279142263"
    sha256 arm64_sequoia:  "156abee096126843dea45d4b863b41cfaf28f9acd4fd8932b1388b981b299e5f"
    sha256 arm64_sonoma:   "8cd30c690fd15b9a98a0c7ebf41c7529d6c1fd06467290d228eb585d5de04d9e"
    sha256 arm64_ventura:  "40d137796340727ecdbb3d1c82a2fe46852cd944eec6cc30d18fe2b8a11e1e97"
    sha256 arm64_monterey: "64b61bdd18dca5533f6bee2239e0c0eb8740b324697c58e03249c840b66d87d9"
    sha256 arm64_big_sur:  "2592140c0bf2f8e5889f3e2020e163d097b6256bde001139dd88b778f7a985a6"
    sha256 sonoma:         "8c1ed7c9caa2cb4c5bd596b7ef1ff34b71769a1cacd84994934d85ecda801295"
    sha256 ventura:        "d58cfe18f25ef00cf2ccf976de9be9d7ce169f67370710aa596d82c0b1722396"
    sha256 monterey:       "46b86e8f4ff8565977416468316300d749bc65850d5c6fb6afc4b5d8cbcf9162"
    sha256 big_sur:        "9d4ae5da430d85f09f2ef7a2b5292976c3db781f80fd1b249e9d0caa05f74c4e"
    sha256 catalina:       "a41b568910292b2119d0f63f53d5015d781b03576a58f08d397535560d407bf5"
    sha256 arm64_linux:    "0fc3fd25aa157f655c7c9e98252b638f7233bb98de481e07808270df7f390a8f"
    sha256 x86_64_linux:   "9823885d8c5febf0b8415e6ac455fec62834b65b75333eec2a314dfeaf2bfd61"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"

  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `use_manual'; pinfo-pinfo.o:(.bss+0x8): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pinfo", "-h"
  end
end
