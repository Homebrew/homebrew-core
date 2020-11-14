class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.4.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.4.tar.gz"
  sha256 "bfc6255ead837e6966f092757a697c3191c93fa58323ce07859a5f666d52d684"

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "65829db6f4cead3afc2fed55266f10f826873f50d8f958bf17dc2b0b2837aeea" => :catalina
    sha256 "85a0ec8fff24c0522924fb1218e8e85deb60a88d2357ccf9c23c963240935ebf" => :mojave
    sha256 "1d0e17197d67e4fe3b9cc6e658faa98de0e9dd92715393e49b96050f823489f3" => :high_sierra
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
