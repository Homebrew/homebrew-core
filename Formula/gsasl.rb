class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-2.2.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-2.2.0.tar.gz"
  sha256 "79b868e3b9976dc484d59b29ca0ae8897be96ce4d36d32aed5d935a7a3307759"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3a9246f399e33a4274ccacfe96d46140e0130a171a991cfdebd27e417d142022"
    sha256 cellar: :any, arm64_monterey: "126a0ded684a9349c873c37caa3d36779a9389891ad50fe8ff042add39d64374"
    sha256 cellar: :any, arm64_big_sur:  "de5f7a8910fbc88acdde0fa7513a86b492a5a6bbb9ab05934d690a59ac17a90b"
    sha256 cellar: :any, ventura:        "ad6dad6e655aabb9df197fe7e3198505e317d9b76a2c05146b27eacf46897d47"
    sha256 cellar: :any, monterey:       "bee461c1291a0341f1a02df6daab52ea23eccf1f5aeed77e0ec846a5252be02c"
    sha256 cellar: :any, big_sur:        "06238f587cee9d327614299a30577b01c64c49a037754c893ff05146fc3ad167"
    sha256 cellar: :any, catalina:       "2b6cad9f39e375aa026c2b7b4bbe774a4c6cd6cd5319ae8500111000f85e3575"
    sha256               x86_64_linux:   "2ad19aa5ffdcf833602a2761b40492be8cfed8fb185713eaaa39c4b35d8cd68f"
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
