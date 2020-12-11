class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.8.3/fwup-1.8.3.tar.gz"
  sha256 "32354c5581a666320ebe951ed9b85efac270e20cfe8dbd5a50c73cefc5dd2e23"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "6c13967bf80a05f2133f617952e4bb2b50087984f55af2e75266113cb865b225" => :big_sur
    sha256 "74af7cfb5ed18a50e9fbd56c4167f7bc3c5ebeec69cc8c7660b80e20020739b8" => :catalina
    sha256 "4e33b196f1f611272cf007528088ac485a19bf0fadbb32b1c4d3b8180540bec6" => :mojave
    sha256 "77a1aa5b48fca51379c19531764e776bd795d4ffbfd61dd2aafbc50bdc33219c" => :high_sierra
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
