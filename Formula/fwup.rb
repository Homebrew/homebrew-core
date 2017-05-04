class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.14.2/fwup-0.14.2.tar.gz"
  sha256 "4ca9ce1c408ca110dfc1de47f0981e052c7da5d11780f7b290056ef4367b28fa"

  bottle do
    cellar :any
    sha256 "a7b537a6466c33c29dec9a8470835d0c0c3ffae0355adcfaa1f51e7e43fda4a0" => :sierra
    sha256 "21a2fd080d2b203e088e1712b6a0e76594828e131c37b83ae56c9d6f0202225a" => :el_capitan
    sha256 "61f692e1df3c647f6638b23536de5e8d7f44dd7379419d97b2fefb83c351b0f3" => :yosemite
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
