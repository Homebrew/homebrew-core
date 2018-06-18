class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.2.0/fwup-1.2.0.tar.gz"
  sha256 "74cc3636bc3923c676c6e95da65c611d47914452eebfe6110a6850be99855acd"

  bottle do
    cellar :any
    sha256 "f86e4b6a69b7e5e6608fb2b0951ba00b3c7c6e6c98dc2b4cac3caba4f3f65735" => :high_sierra
    sha256 "a8fd7141c7b34959f9c2cfb05ccaaf0b1219bd2af5949cdf14bb7a2ce74e84e5" => :sierra
    sha256 "97e2c68121acf424af31355d19b96a6536dd05b4c92cc6d8459a045d165461c1" => :el_capitan
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
