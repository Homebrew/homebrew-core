class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4173/pcsc-lite-1.8.17.tar.bz2"
  sha256 "d72b6f8654024f2a1d2de70f8f1d39776bd872870a4f453f436fd93d4312026f"

  bottle do
    sha256 "d144b95c0db7082ad21938f4c2e909bfb44f26e90bac8278d809c99e3840b876" => :sierra
    sha256 "54683ac6133d00972c5a88067aa7417bded62ceed95c0763fb3ac89518269055" => :el_capitan
    sha256 "55c0449cd3b8dc7ef64de836127f9e599896d50ae5cf774b416f49789665a01b" => :yosemite
    sha256 "1c8b7ffabc889c164fac3fc6ff6f1c6f49e1c510ff46359bca544c8978075480" => :mavericks
  end

  keg_only :provided_by_osx,
    "pcsc-lite interferes with detection of macOS's PCSC.framework."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
