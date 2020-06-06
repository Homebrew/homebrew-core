class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.8.0/fwup-1.8.0.tar.gz"
  sha256 "92912386d3ae11d68bc9793242403133d08b01fea3f5eaf481b8bb1aac18c9c6"

  bottle do
    cellar :any
    sha256 "eaa8838413b1710cf7abdb1cf84aaf5f3813b09620efac1d4b552b8c5f94a3e8" => :catalina
    sha256 "9f47c5153e760eff6a309d1a9ec372adeda8626487d3d41c6360360e0596b5ce" => :mojave
    sha256 "d6f0110302365b2db4dbc3bcf3b66c6435ed5d48f619c2c9beec7d4a74941979" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

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
