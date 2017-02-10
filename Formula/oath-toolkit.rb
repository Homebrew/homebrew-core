class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "http://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.2.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.2.tar.gz"
  sha256 "b03446fa4b549af5ebe4d35d7aba51163442d255660558cd861ebce536824aa0"

  bottle do
    cellar :any
    sha256 "24304b5b3ec6fd838ab3fd42013e3934e247d3f7bdb6cb7fe992b89fe7dbff29" => :sierra
    sha256 "de07bd83252dce6769862320365f0bf340807a67ab27a0bb7fb8db8f9aafc04a" => :el_capitan
    sha256 "c30dabd27de1b1cf4a83f2b24d9929075662e7d18ab69fb7241bfbeaddae9723" => :yosemite
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
