class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "https://hamlib.sourceforge.io/"
  url "https://src.fedoraproject.org/repo/pkgs/hamlib/hamlib-3.3.tar.gz/sha512/4cf6c94d0238c8a13aed09413b3f4a027c8ded07f8840cdb2b9d38b39b6395a4a88a8105257015345f6de0658ab8c60292d11a9de3e16a493e153637af630a80/hamlib-3.3.tar.gz"
  sha256 "c90b53949c767f049733b442cd6e0a48648b55d99d4df5ef3f852d985f45e880"

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
