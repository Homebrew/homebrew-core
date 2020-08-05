class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "https://www.five-ten-sg.com/libpst/"
  url "https://www.five-ten-sg.com/libpst/packages/libpst-0.6.75.tar.gz"
  sha256 "4ca98fed8ba208d902c954d82eaf2bf5e071c609df695ec4eb34af110f719987"

  bottle do
    cellar :any
    sha256 "5c106b4d8bab127e674d0d2c8d69b60431b0eda93ef9c6efcd46f3aeb8aabd11" => :catalina
    sha256 "bdd85c6f92d23eb95c0c0211857e2371dfc2853589b6dbaba4a02fdc28974d36" => :mojave
    sha256 "77a6520ed29669112fb05cbfcfaccf95ba70522ec2e3f361a176a5570953ae2f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-python
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
