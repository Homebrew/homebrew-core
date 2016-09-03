class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  # Can't get 4.7.x to build on OS X/macOS. Pull requests welcome!
  # https://github.com/Homebrew/homebrew-core/pull/1509
  url "https://lftp.yar.ru/ftp/lftp-4.6.6.tar.xz"
  sha256 "d6215e9bff744f29383fb11c61262b7545b2b5a551e1011e85f428669506d05c"

  bottle do
    sha256 "3ccbe19f080a4b4956a2f4e56a2c9d1faa49a58801765e20bc0dd494a6cfa6af" => :el_capitan
    sha256 "df2056435819a12a1c49f5402e49ab1d3ad3da4de8d751f788d0f6844d4ac63b" => :yosemite
    sha256 "586dddd1efa0af036d051f9105e1c3ae838c198ced3b572f5c9e14d349fbbcd0" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"lftp", "-c", "open ftp://mirrors.kernel.org; ls"
  end
end
