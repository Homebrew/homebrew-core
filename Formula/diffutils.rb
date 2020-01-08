class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.7.tar.xz"
  sha256 "b3a7a6221c3dc916085f0d205abf6b8e1ba443d4dd965118da364a1dc1cb3a26"

  bottle do
    cellar :any_skip_relocation
    sha256 "25a2f5fcdfcdf2efa36b97841e45455950fe322e1c642d97a36abbb2662007cf" => :catalina
    sha256 "4ec2a5ef0ca889d6c449b31ed43c797a0656ff7a2acfd913d0f87d8f14248031" => :mojave
    sha256 "fe012f4e981c3df3b2d1b3eb2b77009991148e3bdc08dd974d6f6071108e8937" => :high_sierra
    sha256 "3a04e2e2de81458a8fc75482a97a02883a1cdf231ee340ce30d9a712d0475305" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
