class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.5.0.orig.tar.xz"
  sha256 "2a63118f8c91faa2102e6381ae498e7fa83b2bdf667963e0f7dbae2a23b827dd"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36f4fe5b5c79b4ca8fa0cbf3817fde2003a7ec3b33ce7aab6fc845352ec1ddaf" => :catalina
    sha256 "36f4fe5b5c79b4ca8fa0cbf3817fde2003a7ec3b33ce7aab6fc845352ec1ddaf" => :mojave
    sha256 "36f4fe5b5c79b4ca8fa0cbf3817fde2003a7ec3b33ce7aab6fc845352ec1ddaf" => :high_sierra
  end

  depends_on "gettext" => :build
  depends_on "python@3.8" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
