class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.5.0/fwup-1.5.0.tar.gz"
  sha256 "16d7e4ecaea0b1b226c0592973daa734cd2c04236129c8eb81ab01983d9632e2"

  bottle do
    cellar :any
    sha256 "63e0a26a982232935e57d87191983681e4b83b61e8348649e4e779ab454e4436" => :catalina
    sha256 "1462a21bc6c680f8e93252819af956e4301d6c1374359574e7ad4720c025150f" => :mojave
    sha256 "bb9433905100045df7d383514b0c71e34b097141d8c33a4ed08287e9b29cf230" => :high_sierra
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
