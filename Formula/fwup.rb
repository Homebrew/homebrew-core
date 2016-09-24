class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.9.2/fwup-0.9.2.tar.gz"
  sha256 "6c2727be22761b7be2ec47c084a9c6e8d0b701bae14f09dc45faaaadb3d78c23"

  bottle do
    cellar :any
    sha256 "6285befc0347f09cd250d2cbfe30e962c205711977e51db29c6ffbc06ca5f53e" => :sierra
    sha256 "c39917387c6b3c79145e871abb476648bed2219aec02f08db306c85a5e2328ae" => :el_capitan
    sha256 "886b056997e2a0443d462f27a073ee09a49f1100cba37273247c7995c7082d11" => :yosemite
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
