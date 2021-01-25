class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lzip-1.22.tar.gz"
  sha256 "c3342d42e67139c165b8b128d033b5c96893a13ac5f25933190315214e87a948"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/"
    regex(/href=.*?lzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dd3e7b00a64e6de1f1cbb0446c2a3c0dac5033dd9b2de5f52fe56d7375c0d339" => :big_sur
    sha256 "78014ac2f6011ba98beeabd7aa79e37b6ee78a5e9c72b7bf7594005bfcc7f082" => :arm64_big_sur
    sha256 "91a7214e357c949e0a06736e6a73eb667c0c487efaeebeb4df6fae99ee660575" => :catalina
    sha256 "7c4d9d33bda8dd4043a48903d9348e683c1c64c1b0ab39b1680fcaadb952896f" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system "#{bin}/lzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
