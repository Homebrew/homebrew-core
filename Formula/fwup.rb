class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.2.0/fwup-1.2.0.tar.gz"
  sha256 "74cc3636bc3923c676c6e95da65c611d47914452eebfe6110a6850be99855acd"

  bottle do
    cellar :any
    sha256 "80a28135e62409affd6bc8c5e97032e367539136e8511b9383740afc4564dea1" => :high_sierra
    sha256 "2b1da27efb309242f5048d3eefbff08dd023543770abe7cf0d86ec94a3d67619" => :sierra
    sha256 "f9befbd47a3c2a978ab00d7bb59491a8736ec22ce7127c401be2d5146af9c2b9" => :el_capitan
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
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
