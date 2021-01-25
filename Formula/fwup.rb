class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.8.3/fwup-1.8.3.tar.gz"
  sha256 "32354c5581a666320ebe951ed9b85efac270e20cfe8dbd5a50c73cefc5dd2e23"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "5f66239fb94a6b04ffbf6e74d2f3a6ebd083625faa78b96ee8c671fd33919e94" => :big_sur
    sha256 "24af6cc94eb8d03ab198e93d451a56933751f550a822d5b4dba69d62fa989d12" => :arm64_big_sur
    sha256 "c7f3841b362480d6b900147a0155948fa079728e10709f695409e122fcbec4de" => :catalina
    sha256 "a7a157b8950cd5929e1c525012835880f6f9cc7e1e626ac33a0f49938b6a957f" => :mojave
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
