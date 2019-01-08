class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.4.tar.xz"
  sha256 "4ebc271e9e5cea84a683375a0f7e91086e5dac90c5d51bb3f169f75386107a62"
  revision 1

  bottle do
    sha256 "7758a9fae5106d3e7f43ae84f34ae0801b73430907afbc3526a6b49a4bccef88" => :mojave
    sha256 "648f4e7d3b8f26659cc684b545d4d14ed0e070be7174ff072b69502917f30613" => :high_sierra
    sha256 "3850131c9cc3047d8f041744c4245f6f3684093f3de2815fa8bc56ea1896c888" => :sierra
    sha256 "080ba35e879de061f9c794bb3ee59f32259897395dd6b774471aed16a91279f8" => :el_capitan
  end

  depends_on "libidn"
  depends_on "openssl"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn=#{Formula["libidn"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
