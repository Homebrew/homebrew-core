class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "ftp://ftp.invisible-island.net/luit/luit-20180628.tgz"
  sha256 "7b84f63072589e9b03bb3e99e01ef344bb37793b76ad1cbb7b11f05000d64844"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/luit", "-list"
  end
end
