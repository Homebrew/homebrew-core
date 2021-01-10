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
    sha256 "98412a7d26e986502ad50442e7d68de09809617d4fb16f5761bfe9506386780d" => :big_sur
    sha256 "ede6a7fd4bf00698e706fd9f99dcc4712403fb92eaf10c40669ce493483cf4ed" => :arm64_big_sur
    sha256 "e69bdf0e079d8b94221625310d0a0f6ad5cee544b4055d6a55d721f791a5b7f9" => :catalina
    sha256 "54716b72b43e41cb8d9912fe3f61aeef651f890bf42f8b92482adfd0f2c99798" => :mojave
    sha256 "bfe47a5379c4d793e15d1d71f5f6b12047a486e2531718f31f675683d54df595" => :high_sierra
    sha256 "aba0ea18470d9aa4f619c0f6c133a4f459d4b02327ff539a44a1f473a2112369" => :sierra
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
