class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-1.10.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-1.10.0.tar.gz"
  sha256 "85bcbd8ee6095ade7870263a28ebcb8832f541ea7393975494926015c07568d3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "8f14a65d314339266a3b82be273714e0450b9e392a96372c691e736e2422f6a8"
    sha256 cellar: :any, arm64_big_sur:  "29fe198c3ae4c00a487b94cb8e711cb1c293c3a28bd0fb21f6f56e18cf1c1e5e"
    sha256 cellar: :any, monterey:       "7d76bbbafef8b2d065d6c32289e5204620c0a8ef888a3758aca842748350c977"
    sha256 cellar: :any, big_sur:        "42ef3c24427817c75c74804f31cd0d039a9900c8da5f96dbf9ab7b76e2563168"
    sha256 cellar: :any, catalina:       "6f7aa6d0a2276a8d3434f2c16cfd7f60d85fbb4204194dcf6a678b7bb8c4e0f2"
    sha256 cellar: :any, mojave:         "f9518412c5a6f631a78ef1ed3ed8989914446f2be1bad0de786ad82dc4c190e1"
    sha256               x86_64_linux:   "4b5524f680771e938f850d849bbb39e71f2f89fe95fe5626fe129f961a2e6505"
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsasl")
  end
end
