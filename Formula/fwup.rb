class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.15.0/fwup-0.15.0.tar.gz"
  sha256 "8dce471507e2109be769b0fda013ecabf8b8c44acb0beedb37b75b6da9a4ea7e"

  bottle do
    cellar :any
    sha256 "03f89dfce095fbb2da36a785e78e4c5fc09a83f541c0044f6087bbbb4d8c9ea9" => :sierra
    sha256 "3d819147d307bb2edf71a4963b1177a94fd930a0b79583bd358cdbeb9602fc50" => :el_capitan
    sha256 "601b09865e549805f502c134a52eb9ce65f83c43e5bf62005a5fad78bd36063b" => :yosemite
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
    assert File.exist?("fwup-key.priv"), "Failed to create fwup-key.priv!"
    assert File.exist?("fwup-key.pub"), "Failed to create fwup-key.pub!"
  end
end
