class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.6.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.6.tar.gz"
  sha256 "fd68b315c71ba1db47bcc6e67f598568db4131afc33abd23ed682170e3cb946c"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "25e229ea25ead409a0dd07c65472674e8909fbd483ef30cc4b0a03ce38de0027"
    sha256 cellar: :any, arm64_monterey: "d12d5f53c630491e0db01dd5955e9dd23baeae9080df3f24eb726ccf359aaa97"
    sha256               arm64_big_sur:  "3e54014feda461a1aa6f68f71570c8be14076aac4a6823345b76b10feba0cf94"
    sha256               ventura:        "1177eafec71650b3a23f4d034ad4b15fd094ca6f6623bb3fbb69133b1486c316"
    sha256               monterey:       "a3b5fca2b9fbe382935b54efa49d56f07bb1f637cc1c17d90418a33ce265e92b"
    sha256               big_sur:        "ed6ceb54edc0b0bea449a75c756b604c6204f6fd80c9e280ce57b1e3d7140ac7"
    sha256               catalina:       "04c85d25d9c1e8cac2164a4b538344f95181346fd3170e65e43173aca6770b6d"
    sha256               mojave:         "136fc9c533486f31645fdd6594d96fc8f17487439248b78a8c42a868ce7aaacb"
    sha256               x86_64_linux:   "3ea5398bb38297c062a54cce0ee803487211cf9f16c7697981d67a3edebd94e6"
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
