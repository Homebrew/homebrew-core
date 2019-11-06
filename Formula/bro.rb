class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.6.4.tar.gz"
  sha256 "a47a9cdcef0ea14d5f70c390ab266f0333063ff96f3869a5f1609581a1d1ceb7"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "ca782c79c23a584194f55ac2503f1f2f7b092b5f500fa7e5d019e538b226e8da" => :catalina
    sha256 "b77ba6c36ab178d8023f247089f405c3eba2ba79b06801cef517fab1b1cf7464" => :mojave
    sha256 "fb7fd4a18ef08bf3bc3ab2247021bcf18bc721ad7394db4abb594f1e39e735ec" => :high_sierra
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
