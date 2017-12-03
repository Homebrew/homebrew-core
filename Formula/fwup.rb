class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.18.1/fwup-0.18.1.tar.gz"
  sha256 "66bc2346dc624b86cb17e6d96556ddee9c052e14eb953682a4fdc8f9c6adacb6"

  bottle do
    cellar :any
    sha256 "390ee6cccdcb27faf6347a7b257b7b12facc73d526b05db1f390bf8906459a06" => :high_sierra
    sha256 "8941f709945642352693e2a065ece41a282927b1e4ef371ce919b8f52431a001" => :sierra
    sha256 "c92970b16ef75a6361728096111668c13cf105040a62e17934fcdf86de2a995d" => :el_capitan
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
