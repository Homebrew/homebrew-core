class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.2.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.2.tar.gz"
  sha256 "b03446fa4b549af5ebe4d35d7aba51163442d255660558cd861ebce536824aa0"
  revision 1

  bottle do
    sha256 "2d8c7bdb74130c7cf5f429f4d53cdb4f777b64ebbb39b49e1c7aee5d672594cc" => :mojave
    sha256 "8734ee8d2b5d4766be9d67868244e41cc0c60a7f6c2b729803be226e989e8900" => :high_sierra
    sha256 "4b7b14d0370e4bdb2b05b6d3926adcb7a7c47f6fae9169f0d407237a81588d39" => :sierra
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
