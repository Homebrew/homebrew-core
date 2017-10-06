class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/archive/v2.14.1.tar.gz"
  sha256 "acf6820d98a792faf309fc9acf22f7caf4b8a4b7001072c8f546b3c4fc755e39"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "c9bf0b0f9a069772f8f7236bb5b418f9ce643190aa37b130122be99c6640f87f" => :high_sierra
    sha256 "b7fd863913d2f6aa3f3e47d7a78b24fce8e7076aeda94ddcf21e80f4695492da" => :sierra
    sha256 "77954a137d7c9cdf6a87fdc8df6f9326b11d229d2e02c69f3caf4871734b0467" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
