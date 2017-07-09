class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.15.2/fwup-0.15.2.tar.gz"
  sha256 "353f50720e89afad9b4e9c91d0f98cdbc7b10dde767a6221ee75465efa23aa97"

  bottle do
    cellar :any
    sha256 "a058a81ef0633345bf308bff1d4cc624f33a55ed80bc280706fda1047a4d78f1" => :sierra
    sha256 "5d168a71e58c9c2b82bf5fa70d7e96cf418a75b586c094d58758bb2380a623e4" => :el_capitan
    sha256 "25580e16f6627a480a47f36db47fde6edb0e7ed2b474e34950e13426edf7f108" => :yosemite
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
