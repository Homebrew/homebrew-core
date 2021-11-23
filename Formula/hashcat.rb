class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.2.5.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.2.5.tar.gz"
  sha256 "6f6899d7ad899659f7b43a4d68098543ab546d2171f8e51d691d08a659378969"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 arm64_monterey: "548332afa0203273e4d9a1a52409236142e24eb7e747a8fd33b4a9b298c9ef46"
    sha256 arm64_big_sur:  "7b9727bdfbc0a602aa7ce3b0430b0d12fddb46a78e7f9077d79a1cf6dbbc0313"
    sha256 monterey:       "0736726f1d60e51e6c42b8cf34dd87fda5dfa4924cd3d892eda6f4f698d4da86"
    sha256 big_sur:        "21a36b5a036e7f52c7bc47427d0451a33abd3ee08066961c33bc0f04494af847"
    sha256 catalina:       "84636fb6c2606364c8516346782758641c0c5bb5567936ada4fa2504ea75307e"
  end

  depends_on "gnu-sed" => :build

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    system testpath/"hashcat --benchmark -m 0 -D 1,2 -w 2"
  end
end
