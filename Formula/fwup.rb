class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.6.0/fwup-1.6.0.tar.gz"
  sha256 "4ef4b316fd9f2368ec7d0a18da0aa08091b920d57c67d853d0227a367153fecf"

  bottle do
    cellar :any
    sha256 "8f26f8b0c20a3cc285b27b9327bf7e1a2617224b3003e04c143eae0dd11d31ae" => :catalina
    sha256 "37c5e77fc5ccc270944e061a6c618194f7ce7e4398be7984fdc3f5cbd765a8eb" => :mojave
    sha256 "b0304fd711a820de849bd4554b16b4a037414b82cc55bcb845b6983193ac8ed2" => :high_sierra
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
