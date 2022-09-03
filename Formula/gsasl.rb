class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-2.2.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-2.2.0.tar.gz"
  sha256 "79b868e3b9976dc484d59b29ca0ae8897be96ce4d36d32aed5d935a7a3307759"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "dbe49591e9788dc2c44090bbae030d3541d527d1245eb739f213b16a2e04ffba"
    sha256 cellar: :any, arm64_big_sur:  "b9ed09d62ce6512a251f0f2854ea8b9ca1ffa55dc60295d734aa3b6657067960"
    sha256 cellar: :any, monterey:       "455b3d081fdd6975bb912c0e98c0aad7847e832d290257746a2877d77044fafc"
    sha256 cellar: :any, big_sur:        "e227dc44fb334144a7227819b63b2ca3b874ef3c65a1c42baece683769a50bc5"
    sha256 cellar: :any, catalina:       "bdafb4164a5d387abf68523afae178d0646624002f1df628c1a20dd27f82d282"
    sha256               x86_64_linux:   "5da4b3ddd5711f42eaf0fd27278489408122c3896337f8bec1a38fdd95344675"
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsasl --version")
  end
end
