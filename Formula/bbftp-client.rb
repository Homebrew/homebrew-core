class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  homepage "https://software.in2p3.fr/bbftp/"
  url "https://software.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  revision 2

  bottle do
    sha256 "6c2934f5a33b59be8421730ee9a7ec92abb339e8d1825f6e561bad8fd607e23c" => :mojave
    sha256 "b4fca3a4abc73dfdec803221add551ded24fd1ceb7b14d682a283fde20d4740d" => :high_sierra
    sha256 "a1582472acced4bb8462ee707314365b2103adfb42efc0624d3cfa9c6f378e6a" => :sierra
  end

  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    # Fix ntohll errors; reported 14 Jan 2015.
    ENV.append_to_cflags "-DHAVE_NTOHLL" if MacOS.version >= :yosemite

    cd "bbftpc" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bbftp", "-v"
  end
end
