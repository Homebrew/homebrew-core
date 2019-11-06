class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "https://hamlib.sourceforge.io/"
  url "https://src.fedoraproject.org/repo/pkgs/hamlib/hamlib-3.3.tar.gz/sha512/4cf6c94d0238c8a13aed09413b3f4a027c8ded07f8840cdb2b9d38b39b6395a4a88a8105257015345f6de0658ab8c60292d11a9de3e16a493e153637af630a80/hamlib-3.3.tar.gz"
  sha256 "c90b53949c767f049733b442cd6e0a48648b55d99d4df5ef3f852d985f45e880"

  bottle do
    cellar :any
    sha256 "45c4558dd261444364a656c8afb48f0ec7a95efe27f2b7e65784687081f6e6c3" => :catalina
    sha256 "cef1ba3b5dcb592c43686f76e9167ee60c19331672164bae5186620d6db7d382" => :mojave
    sha256 "1a347bc581ea06ee93d2c2ddf955f54a6997484b91aabd304fdc077bd70936b9" => :high_sierra
    sha256 "eb3ce94a8e752ab792dd306221b74d0a254695d64bd818fbb841ef068b6b7600" => :sierra
  end

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
