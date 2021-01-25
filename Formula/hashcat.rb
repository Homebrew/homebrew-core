class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  # MacOS curl complains about https://hashcat.net SSL cert
  # See https://github.com/Homebrew/homebrew-core/pull/56503#issuecomment-660728358
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.1.1.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.1.1.tar.gz"
  sha256 "39c140bbb3c0bdb1564bfa9b9a1cff49115a42f4c9c19e9b066b617aea309f80"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 "b0d2f4ed9f9d8450f1d79285869b69909d2a08f9393ec2d8b39cb05dcefb52b9" => :big_sur
    sha256 "0b7ed83aa1cad6c2b763dee4495d2f56cf5d045dfc8df730a81c4ec35cd453a0" => :arm64_big_sur
    sha256 "dd7e0ba6e2441b0517b55ef243efc8f8be3dfd1550b83033e264057a677e8fa2" => :catalina
    sha256 "ad145c3ffb0ffb779dbdde3e0c1c0329b2b45d491e76ba0b92c48c02028e51c1" => :mojave
    sha256 "2e1cbf12a3f5ed5fceb622e5f773d102edfaff06a847df925456e92dd6ca91ba" => :high_sierra
  end

  depends_on "gnu-sed" => :build

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    system testpath/"hashcat --benchmark -m 0"
  end
end
