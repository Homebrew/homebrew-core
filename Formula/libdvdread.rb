class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/6.1.1/libdvdread-6.1.1.tar.bz2"
  sha256 "3e357309a17c5be3731385b9eabda6b7e3fa010f46022a06f104553bf8e21796"

  bottle do
    cellar :any
    sha256 "83bebe58015f6f34973afa003934f183e7ac9202f5e579cfd12536f9ceac1719" => :catalina
    sha256 "7405838fee2b93209c2bd0834db89c2a2334a94f7d368feb87599da1b08062f6" => :mojave
    sha256 "c881a8c1c872d922f45bf8a692b9d79b5f6ade1a2f4a48d470d05491bc017436" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libdvdcss"

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
