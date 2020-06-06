class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.8.0/fwup-1.8.0.tar.gz"
  sha256 "92912386d3ae11d68bc9793242403133d08b01fea3f5eaf481b8bb1aac18c9c6"

  bottle do
    cellar :any
    sha256 "613a60321d95e32435c2522a4e29982bef728e6538490759155536c8ba4b8ec6" => :catalina
    sha256 "5fb03657d9139079a57cf03b1e4b51bf5259e33988f6d3ed7cd3dffad5838fb2" => :mojave
    sha256 "e4bbe839f3d3367e9a3c7be541ebd0825d8b7abcbee5e07dee6edee95ef054d4" => :high_sierra
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
