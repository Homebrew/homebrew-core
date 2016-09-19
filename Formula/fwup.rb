class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.9.1/fwup-0.9.1.tar.gz"
  sha256 "9ad389c96429e6c29d9c45d145de0e7c04968794864a872ce939933e0ab5f4bd"

  bottle do
    cellar :any
    sha256 "25bc2fdb8090f0cebcf0374cd85f8b8ea220ee1792f7f6b214265abc28b6f5ff" => :el_capitan
    sha256 "f014b3a540cdb05037e3ed8efd2b12f864302c400cbc23fd745c6a4cc026a93d" => :yosemite
    sha256 "89488d53335a51e0a906f035e3cc081f21eb9cb78b9e965ebfe113252eee8d6c" => :mavericks
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
