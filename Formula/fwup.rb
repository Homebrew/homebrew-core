class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.15.4/fwup-0.15.4.tar.gz"
  sha256 "0594ae5dd1014a610881b21289a8415c8b78ea012d2a5567d57f986625669167"
  revision 1

  bottle do
    cellar :any
    sha256 "082a2a2355ccf742ee41444aa0acc53e35aa895194ba31cd9d60df2c3eff338e" => :sierra
    sha256 "a972b47210a86cd761cfd95d00f59b29838420d387bb491410f72fad85c190cd" => :el_capitan
    sha256 "9a2ed135cf9292c118169c698db7a0a50df45d06551a081c55553228c69c0524" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert File.exist?("fwup-key.priv"), "Failed to create fwup-key.priv!"
    assert File.exist?("fwup-key.pub"), "Failed to create fwup-key.pub!"
  end
end
