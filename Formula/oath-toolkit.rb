class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.5.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.5.tar.gz"
  sha256 "d207120c7e7fdd540142d04ca06d83fb3277c8f2fb794a74535d04b2aa0ec219"

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "1dd544c61783354f225bbb25ab41645a0acf98693ef72fcdaba64da8c70efaf6" => :big_sur
    sha256 "5fff47a435c0f709320da77ccdea7bcc2139e094071c87b211ddb3fbc57e1b32" => :arm64_big_sur
    sha256 "03ab59527335488e08f4d77527efa444e7e732d7aa8c2e4c852fe1d829d10146" => :catalina
    sha256 "c4ca091169b76af62be799ebc0d56ccb621ebc1cb8b790e31867ab0b0fd21e45" => :mojave
    sha256 "56cba35b06fd322068776ac49afc3f040fcba5defe28fdbe937cae7e1d01c1e7" => :high_sierra
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
