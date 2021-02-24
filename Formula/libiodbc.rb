class Libiodbc < Formula
  desc "Database connectivity layer based on ODBC. (alternative to unixodbc)"
  homepage "http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/"
  url "https://github.com/openlink/iODBC/archive/v3.52.14.tar.gz"
  sha256 "896d7e16b283cf9a6f5b5f46e8e9549aef21a11935726b0170987cd4c59d16db"
  license any_of: ["BSD-3-Clause", "LGPL-2.0-only"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9179490e07b80540b31a531babb6168cbd0ea2e10dc994a38f6e5ff8ad2c9f67"
    sha256 cellar: :any, big_sur:       "981db56543c7f668350a12248aa9047de688e9223bf502a93762ec0e53867d40"
    sha256 cellar: :any, catalina:      "288802927c2719db23449d5df0ca88c7b9c267c5755a9fa742f5c031d31db552"
    sha256 cellar: :any, mojave:        "40f53ec2a76bac0bb87697bd2e9cd06ee68d4e83c0e73cd901e569227d6df486"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "unixodbc", because: "both install `odbcinst.h`"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iodbc-config", "--version"
  end
end
