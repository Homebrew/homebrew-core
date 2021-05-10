class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.7.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.7.tar.gz"
  sha256 "36eddfce8f2f36347fb257dbf878ba0303a2eaafe24eaa071d5cd302261046a9"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "3e54014feda461a1aa6f68f71570c8be14076aac4a6823345b76b10feba0cf94"
    sha256 big_sur:       "ed6ceb54edc0b0bea449a75c756b604c6204f6fd80c9e280ce57b1e3d7140ac7"
    sha256 catalina:      "04c85d25d9c1e8cac2164a4b538344f95181346fd3170e65e43173aca6770b6d"
    sha256 mojave:        "136fc9c533486f31645fdd6594d96fc8f17487439248b78a8c42a868ce7aaacb"
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end
