class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.4.0/fwup-1.4.0.tar.gz"
  sha256 "238202a83f5ba85d6a0b4ed8f96015701d1ae60f41b5e5ef750e28ae2138d670"

  bottle do
    cellar :any
    sha256 "13712afbc26bcb3c46056232e066472b9d60dcb48b96049905b631d4f08337d5" => :catalina
    sha256 "b5629796fb0491f25dcfa12e99bfc53afe2da1d159882e0dce31753f5522f30b" => :mojave
    sha256 "0c1dd39d731d040a77e244a1ea3affd7d5412e559e39de8ed45284741426f240" => :high_sierra
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
