class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.16.0/fwup-0.16.0.tar.gz"
  sha256 "5375421774d073773fb410a5152755a256a445d43d0bc0523ddf6c9d4657a4c2"

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
