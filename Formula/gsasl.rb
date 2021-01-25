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
    sha256 "42ef3c24427817c75c74804f31cd0d039a9900c8da5f96dbf9ab7b76e2563168" => :big_sur
    sha256 "29fe198c3ae4c00a487b94cb8e711cb1c293c3a28bd0fb21f6f56e18cf1c1e5e" => :arm64_big_sur
    sha256 "6f7aa6d0a2276a8d3434f2c16cfd7f60d85fbb4204194dcf6a678b7bb8c4e0f2" => :catalina
    sha256 "f9518412c5a6f631a78ef1ed3ed8989914446f2be1bad0de786ad82dc4c190e1" => :mojave
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
