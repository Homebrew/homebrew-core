class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.10.2/fwup-1.10.2.tar.gz"
  sha256 "b1fa346e02b984816d5914bfc5f37a55639a147d24a87727dfc01aa9d7ae90f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e483cc908d13ca2c5f77329acfc9f0a2e07c309eaa5cd654cbb92fabebb9521e"
    sha256 cellar: :any,                 arm64_ventura:  "c4a7b6a2f48c2ec1193f646f627db6a185af212913bf171be2d46ebbd8f3a90f"
    sha256 cellar: :any,                 arm64_monterey: "6ce4ca5b3844c3930db020e6088482170c4efb57dbdbb31f1bf6aff9bba05527"
    sha256 cellar: :any,                 sonoma:         "5165cc003d518893dec2538c500b7eaaa15137b304a9511e06ac08b057bc4a3c"
    sha256 cellar: :any,                 ventura:        "ec75edba64377a46b630c10c89aed8be8a45ee5e5889ff86497141b48cfe7374"
    sha256 cellar: :any,                 monterey:       "c11de80f300f46bd049904f89b1745e02a581fb30763632c74b9da812bffa493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "538295ec30530fcee960c6e56c7e40bfe0899c16e95d9b4b0b97f9aefe9cd94e"
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
