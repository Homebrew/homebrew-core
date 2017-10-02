class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.15.4/fwup-0.15.4.tar.gz"
  sha256 "0594ae5dd1014a610881b21289a8415c8b78ea012d2a5567d57f986625669167"
  revision 2

  bottle do
    cellar :any
    sha256 "15a2f61a12cf0b8f839a6d1c3c5627cfe49de9f30cb65cd7f302a9b11358a373" => :high_sierra
    sha256 "8b620a8ac59a18782af4e6884cc2275682d8017a61aaba21207d381120cb80c4" => :sierra
    sha256 "8585c666a1f67927196cdfe982335c590e76b22dc9845603e84ed2d514d1563e" => :el_capitan
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
