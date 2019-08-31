class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.6.2.tar.gz"
  sha256 "6df6876f3f7b1dd8afeb3d5f88bfb9269f52d5d796258c4414bdd91aa2eac0a6"
  revision 1
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "69c4fa4c4b9842e9a5f2aa07c1e02838b88ae73ee9cc02090ff532baef02d682" => :mojave
    sha256 "eff43b1c0b15404696ff6d2323cfb77be9c5d0f7e7a9e65fc11c56056a209e83" => :high_sierra
    sha256 "5ae17948baf2acc7aed24432ef399a3297fa9500e06854b4669434c669c92fb7" => :sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "geoip"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
