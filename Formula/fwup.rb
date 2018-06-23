class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.2.1/fwup-1.2.1.tar.gz"
  sha256 "91f0a29fbbe4bc697694011c02ee0dbac6aaaec22af65a650458860541b5b243"

  bottle do
    cellar :any
    sha256 "4bfb48f3a93e33614e937a2861ee0e91bba8e126c8031be0068dbc50657eeeb6" => :high_sierra
    sha256 "ecd73771139ebbe26df4dcdcef83bcfcc3e0c0b2da3901967d3468fc4608a4b8" => :sierra
    sha256 "41b2c939aad89d79a0008b3b10201aa8492e3b3efc2a83d183809528d13ae0bb" => :el_capitan
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
