class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.2.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.2.tar.gz"
  sha256 "b03446fa4b549af5ebe4d35d7aba51163442d255660558cd861ebce536824aa0"
  revision 1

  bottle do
    rebuild 1
    sha256 "e56c414cf742ef44cef4c904c7bac6138d2fe3dde08d4733fcb6d94c62e75eae" => :mojave
    sha256 "dbf06b9def1ea821269ff0b6d44f54e05c64af1fe57799803de5deb3a355c0d2" => :high_sierra
    sha256 "af3c35a9cd1139b813bf5bbea9b9c0eff5890fc9beff8096d4405218d6398a42" => :sierra
    sha256 "e72016ad2981cdfd75cc76aa8913ad8b41eca71eec82a769addb14cd94fc162e" => :el_capitan
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
