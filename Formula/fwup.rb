class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.19.0/fwup-0.19.0.tar.gz"
  sha256 "6407c2c999babf4ff71f6c533943a3d7c7ddf29c52242f1071d5b5c313f8c2de"

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
