class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.15.1/fwup-0.15.1.tar.gz"
  sha256 "e3ce02dd5cf71783db6028e6c6e9d6d4584d75df91dc175b24863c63d99933c3"

  bottle do
    cellar :any
    sha256 "42ec7f995073e1f4405b9d477d9f9ae1673625107906cdbda2d6582e8b337a7f" => :sierra
    sha256 "9cf7ab44475b6c9e098587c7b2e61967422f7b0acbb432f2fc63dd66d27c666c" => :el_capitan
    sha256 "7398ea5892296e638504fd7c294a786eea9e4836650cd297585b0b7cb0f4f630" => :yosemite
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
