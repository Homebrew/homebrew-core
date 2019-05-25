class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.4.tar.xz"
  sha256 "7d9cffe30999a7b2ea503df9b23ccbf42439b62271c45ebd7b5b04bed0654148"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac5ee4b2a4359a994fe4e6e91772c265ac0cb2632efec60bc3b17c8a2d5614cd" => :mojave
    sha256 "156ff20366981120daa63c3e1c968529d92fe75412b23e238ec76a0c0f304129" => :high_sierra
    sha256 "12d315afd7b4e7f7d5fe5c1a0fdd420e42d31048a5a1b9f02ec65b65e20b4f43" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
