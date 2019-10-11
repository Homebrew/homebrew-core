class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lzip-1.21.tar.gz"
  sha256 "e48b5039d3164d670791f9c5dbaa832bf2df080cb1fbb4f33aa7b3300b670d8b"

  bottle do
    cellar :any_skip_relocation
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
