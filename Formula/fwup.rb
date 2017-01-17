class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.12.0/fwup-0.12.0.tar.gz"
  sha256 "cefa3c213f54583ade0f1ed996795f5efdbb97fb10ca1b40fd9d84cc98281ece"

  bottle do
    cellar :any
    sha256 "928219ae31b7565941c63a6f72a5dce1765f298dac7508eae6031b6895230c03" => :sierra
    sha256 "60bf53c57014a63c008e07dfb60b08ffa13b147e929ef8fed87ff77743b15387" => :el_capitan
    sha256 "f5a6bdb554d4f1d6faed27f50084a657dc6f0de02c009b9389ba539e3f3c9fb5" => :yosemite
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
