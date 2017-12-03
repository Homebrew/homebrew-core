class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.18.1/fwup-0.18.1.tar.gz"
  sha256 "66bc2346dc624b86cb17e6d96556ddee9c052e14eb953682a4fdc8f9c6adacb6"

  bottle do
    cellar :any
    sha256 "6d10d42881af956a9e8c104feedf199c9e9cb04448df726c228c7ffa74c3fc3c" => :high_sierra
    sha256 "f547b1cb0afbfc5111832b6736c1c00ab5ec3899605e8fd8ca3c9fe30e7ecceb" => :sierra
    sha256 "2ae77514fbba42ef40ba9174d01a3cec2abd6be8226e5737fc130f8f45d42893" => :el_capitan
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
