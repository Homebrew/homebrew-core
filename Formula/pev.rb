class Pev < Formula
  desc "PE analysis toolkit"
  homepage "https://pev.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.80/pev-0.80.tar.gz"
  sha256 "f68c8596f16d221d9a742812f6f728bcc739be90957bc1b00fbaa5943ffc5cfa"
  head "https://github.com/merces/pev.git"

  bottle do
    sha256 "dbc6f431e9f70bbbf582e07bcbd9cd852413d57adbd213573ec2b4c0ca3c19bb" => :mojave
    sha256 "9f7b8ec7a8796b91524d7fdb5e9913db5afdd220f1fadbbc5a2e32ab7a994e8c" => :high_sierra
    sha256 "c995e2ccdc4fde4e2e1beaa3039421ef8e77cdbe0ec00f1af50d7ba551d2c695" => :sierra
    sha256 "ec81bb70fec6dd27f249a575194c62db766b2e31349224d503ecb1cbf2603c37" => :el_capitan
    sha256 "1013086fe324f7b6147181762541d89dcf4837bd29bd89756d7df23c26fad1f2" => :yosemite
  end

  depends_on "openssl"
  depends_on "pcre"

  def install
    ENV.deparallelize
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
