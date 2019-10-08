class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "https://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.32.3.tar.bz2"
  sha256 "17abe02d043a253b68b47e3af69c9fc755b895db68fdc8811786125df564c6e0"

  bottle do
    cellar :any
    sha256 "67e11f8966ff949902c637dccea47ee5ee341128519050f31f6c87eb74264d99" => :catalina
    sha256 "c22bed7e3ad43221011658fb8acd08481dccd11b0cc5750e6a21502d7da51fb9" => :mojave
    sha256 "50b8adff5f3364626026d19fba9a0c9fef8cf93104b8d6907bcbe8a5f4a136c2" => :high_sierra
    sha256 "1a3656f2fcf778aa32eb734a60dfceccd5e1a702fa6558b11b33cc6f44aeba99" => :sierra
    sha256 "fb93eb5cfa6b222e77ec07569f501fcc03143e9decf306ebd21e9d1c6d304bce" => :el_capitan
  end

  depends_on "libpng"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"icotool", "-l", test_fixtures("test.ico")
  end
end
