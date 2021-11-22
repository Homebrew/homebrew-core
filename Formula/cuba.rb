class Cuba < Formula
  desc "Library for multidimensional numerical integration"
  homepage "http://www.feynarts.de/cuba/"
  url "http://www.feynarts.de/cuba/Cuba-4.2.1.tar.gz"
  sha256 "84935a6f72712e183e8741715f09402c716d1cf816e452a47bdc5dd44b13567b"
  license "LGPL-3.0"

  livecheck do
    url :homepage
    regex(/href=.*?Cuba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01567f5b76f7baad0d2fd5a08083d545d0d0543795e03bb8759953f317090cf4"
    sha256 cellar: :any_skip_relocation, big_sur:       "6fe604c61d01768a99cb42321606f6b5feb5ed709f6d7fb419c3efb3e7e83f3a"
    sha256 cellar: :any_skip_relocation, catalina:      "758999a8bef3aeaf37f38402affd375ff55b4293cbdb52ee76846a25ba7f5209"
    sha256 cellar: :any_skip_relocation, mojave:        "abd47d8d13cfefdaf542675e465b717cb95e8b1a8ba0ca2c3745bbcf0c6bd1d0"
  end

  disable! date: "2021-11-22", because: :checksum_mismatch

  def install
    ENV.deparallelize # Makefile does not support parallel build
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "demo"
  end

  test do
    system ENV.cc, "-o", "demo", "-L#{lib}", "-lcuba",
                   "#{pkgshare}/demo/demo-c.c"
    system "./demo"
  end
end
