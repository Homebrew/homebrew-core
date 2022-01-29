class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20220128.tgz"
  sha256 "42c1805cc529314e6a76326fe1b33e80c70862a44b01474da362e2f7db2d749c"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90da7a202b63169cd56356de9da590562bedd5a97fad44953c0c15d7daaf3b6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66c634b569502332b51e7703d03e9800a55db28e36bc458a791719339663ac4d"
    sha256 cellar: :any_skip_relocation, monterey:       "76e44fa9288ecf0206986ad85441d64e65a080c07b045e83d15bc9a364c397f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea6f7dbf17c79bc18f92c6d409a52732e0b149acc8cda578206a87d27751f234"
    sha256 cellar: :any_skip_relocation, catalina:       "b5adba9840b4bf16453fed0c51ac4e932c3aa2a87d0e5c8134b27dbf74bfa628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ca2a4cdbc4f8c477d1fd35d5bbcdf0c7d502aed0d2b2fbe8eb3bd13753cfd4d"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
