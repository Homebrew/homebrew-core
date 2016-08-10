class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.8.2/fwup-0.8.2.tar.gz"
  sha256 "465428537c13b5ab914f072474d98c742011030e1920d9322aae9716dbb58c35"

  bottle do
    cellar :any
    sha256 "37c05635b211d8274d0782524dcf66756a10b51ebb9e92c706a0d26d6c76c131" => :el_capitan
    sha256 "a74b6830c2d929b1eba899510ab8b81256a3624a88e9d74dc01b81de021f4c13" => :yosemite
    sha256 "bc53a6c476ce4cf0e988a41548efd9a2519a520eb7e641d26ebff90f8b9b8525" => :mavericks
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
