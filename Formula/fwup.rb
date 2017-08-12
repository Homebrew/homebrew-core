class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.15.4/fwup-0.15.4.tar.gz"
  sha256 "0594ae5dd1014a610881b21289a8415c8b78ea012d2a5567d57f986625669167"

  bottle do
    cellar :any
    sha256 "ce72cf839975a2ad14b42b80c38ee7e0e161dd7376cf386aa93e33c5113aa951" => :sierra
    sha256 "2ea57b58a98db74409ab474edad63998bf0c3dce7b5ece84a096cc735a92c2bd" => :el_capitan
    sha256 "25ccb4df3872e6e39893b88957ea7ad2bf19794d2ed1b68b969032b285d542e8" => :yosemite
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
