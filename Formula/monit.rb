class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.25.1.tar.gz"
  sha256 "4b5c25ceb10825f1e5404f1d8a7b21507716b82bc20c3586f86603691c3b81bc"

  bottle do
    sha256 "7439b6e6d39dbd590a9fac177cd41329c2230309e9be785f4717616e91d989b0" => :high_sierra
    sha256 "0b5e3b331ab9cbe1aad86eed9c0b1865484b4879952d96889874ef48e5d095d8" => :sierra
    sha256 "bc2815c8094de5686fb875ceecae6a07b0b066b87593fb6259fb4e038eedc3d6" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    pkgshare.install "monitrc"
  end

  test do
    system bin/"monit", "-c", pkgshare/"monitrc", "-t"
  end
end
