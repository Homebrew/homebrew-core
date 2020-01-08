class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.2.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.2.tar.gz"
  sha256 "b03446fa4b549af5ebe4d35d7aba51163442d255660558cd861ebce536824aa0"
  revision 1

  bottle do
    rebuild 1
    sha256 "24a65399ed4b462a3291c542616e1a5dad4df008dcb116fd12c34030f05135b0" => :catalina
    sha256 "ab9cbc2e7e8c7004c5a3db7fbc4b6a0cbc9560a353a306cba0fa4d1174a46f68" => :mojave
    sha256 "a7fbff2831b4c6a61896c65b482b3db50d2e070e1e74772e7fb929bbd4a586f0" => :high_sierra
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
