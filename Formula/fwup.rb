class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.4.0/fwup-1.4.0.tar.gz"
  sha256 "238202a83f5ba85d6a0b4ed8f96015701d1ae60f41b5e5ef750e28ae2138d670"

  bottle do
    cellar :any
    sha256 "411beb6a6a976a22f59c202a02308c339894da416ae459a747ef337b012df5f9" => :catalina
    sha256 "749cdac349bff16d3cd48ea942488e6a936645a405c21bf29c1ba65602a789df" => :mojave
    sha256 "0ff887162dbb375b7fd85e1a136ffd739fdedbac72072d2af38727c621d6f3ce" => :high_sierra
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
