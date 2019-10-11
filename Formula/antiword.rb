class Antiword < Formula
  desc "Utility to read Word (.doc) files"
  homepage "http://www.winfield.demon.nl/"
  url "http://www.winfield.demon.nl/linux/antiword-0.37.tar.gz"
  sha256 "8e2c000fcbc6d641b0e6ff95e13c846da3ff31097801e86702124a206888f5ac"

  bottle do
    sha256 "7f62624bf238ba077370f6e8e223704b57eee461f2bbaddc47de8e4b5c5a4eda" => :catalina
    sha256 "63b4aa9e31936c405039161b1ae728d76472bb9932a7b460e1fdd7a1276ee5ad" => :mojave
    sha256 "cacd3e8a83231fd139a5b845f17fb99a34f728d10df2eb6289457037ee8c827f" => :high_sierra
    sha256 "6456be83a3f867a0df1121b7c7b6c413d94d1e38bc920c9c5fda73851265fb2e" => :sierra
    sha256 "ffc3b61781ffb2ae04537e34b28a19a4fe33683c534dd2d1504d2ec8d5ef4bef" => :el_capitan
    sha256 "1397c95409d671da764658460eba612b2564d4a0403bfffa667510e05f2fb08a" => :yosemite
    sha256 "4f4938378ed4cad59dc61d652ec8d33b0410f85dd99ac825f1f86eeeedb07402" => :mavericks
  end

  resource "sample.doc" do
    url "https://gist.github.com/bfontaine/f7e29599d329c41737ce/raw/ed4a3c5461924ed3bc18beb6b82681af9ad143d1/sample.doc"
    sha256 "b53b8d1843029b39b65ae7fdba265035c76610b85c2b9511bcade046d75d272f"
  end

  def install
    inreplace "antiword.h", "/usr/share/antiword", pkgshare

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags} -DNDEBUG",
                   "GLOBAL_INSTALL_DIR=#{bin}",
                   "GLOBAL_RESOURCES_DIR=#{pkgshare}"
    bin.install "antiword"
    pkgshare.install Dir["Resources/*"]
    man1.install "Docs/antiword.1"
  end

  def caveats; <<~EOS
    You can install mapping files in ~/.antiword
  EOS
  end

  test do
    resource("sample.doc").stage do
      system "#{bin}/antiword", "sample.doc"
    end
  end
end
