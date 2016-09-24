class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.9.2/fwup-0.9.2.tar.gz"
  sha256 "6c2727be22761b7be2ec47c084a9c6e8d0b701bae14f09dc45faaaadb3d78c23"

  bottle do
    cellar :any
    sha256 "e791699a5cd225967ecc02d10b9407897fcdfe4e08b6e4ca9e4160f64ae95deb" => :sierra
    sha256 "f950ccceadf3be9e531437c3558fe19ddd6c098bdd3e86858c0378cc323b1202" => :el_capitan
    sha256 "877a2b13ce3b3006b3f1e9a136368a71dde2f01b3f633a8265f1cd6289a6a43c" => :yosemite
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
