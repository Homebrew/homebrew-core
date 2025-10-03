class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-410.tar.gz"
  sha256 "28c1b28b320acff3fe46c79748c55370ba4333544e0c27e90a3520d42a9914cf"
  license "MIT"
  revision 1

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1054dcefc6d2f8d2463e1d4e220a720b3ad71e3be1c4cd1467d9c7a0f154c189"
    sha256 arm64_sequoia: "65b0b7edda8a3ebe8dba97e532141dd9b985ec7ec2cc799b00b1086337a35c85"
    sha256 arm64_sonoma:  "92a0bf60d6c4f5a5b57cbe70d6cb357373420514b401bd1a463ced3a1fa3fd0e"
    sha256 arm64_ventura: "8fa61c25c901c6c762ca574b5c398281b579a92e940c2adcdc9cbf452cbf86b3"
    sha256 sonoma:        "16275adaae7a5388bbda493535d734b6a5a9b84dfa3c566d600adb42751633e5"
    sha256 ventura:       "327ae74f956db17289622864bb4e272fe0184ee0c54f1b542c9601160a0e3765"
    sha256 arm64_linux:   "5317f74dd5f53f1e824b2659883704b34bca67fd86256ad573f517de9ab66e19"
    sha256 x86_64_linux:  "03553138132bc05944d3eaa1e23ebbbae75831148c38eed4b4567fd36d2b4314"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libbsd"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pianod", "-v"
  end
end
