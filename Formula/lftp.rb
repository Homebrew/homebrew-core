class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.0.tar.xz"
  mirror "ftp://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/lftp-4.8.0.tar.xz"
  sha256 "7a2880968088b4aeec43b6b6680fef0e065e1dddcce9b409390157e9766b690f"

  bottle do
    sha256 "ccbccfbe7b87c772c1bedec5585481371512143b3ecccc65ef15383c47319f50" => :sierra
    sha256 "14a56b9bbb6709960f647b78a65d3ba361bfa8c0a9b81b3cfd15d79c2b5efd36" => :el_capitan
    sha256 "2137ced78d09beb8561a22ea180adb336da8ecadc91b1c650970ae37ac521f79" => :yosemite
  end

  depends_on "readline"
  depends_on "openssl"
  depends_on "libidn"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn=#{Formula["libidn"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open ftp://ftp.gnu.org/; ls"
  end
end
