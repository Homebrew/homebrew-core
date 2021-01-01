class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-1.10.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-1.10.0.tar.gz"
  sha256 "85bcbd8ee6095ade7870263a28ebcb8832f541ea7393975494926015c07568d3"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "028f7609a7ca21f52e8341cf4c62a019297e0d156c8e3a6526ca68702d6da866" => :big_sur
    sha256 "83b752a80d1e1ebf8fc39b0fe64ffb53baa7fe0aad0c42df69a14bd3624158a7" => :arm64_big_sur
    sha256 "964ad480f7fafd04051fe76a288b5f109766ae39e4329b00f1a268b5082b316e" => :catalina
    sha256 "ac8236d918eea76cb15f196f5a571aab775ba1381e33d2c222a98114a2d391f6" => :mojave
    sha256 "d79efee531f43ebd0019d68f2066fb02f0ab9009ea3b78bddda231b6ddda5a7a" => :high_sierra
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/gsasl")
  end
end
