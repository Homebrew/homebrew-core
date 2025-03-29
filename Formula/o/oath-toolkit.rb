class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.12.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.12.tar.gz"
  sha256 "cafdf739b1ec4b276441c6aedae6411434bbd870071f66154b909cc6e2d9e8ba"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "48cff9d9c17d7a8955db7df8ed9df1b542b1860f45a85ac321534faf1ba9f48b"
    sha256 cellar: :any, arm64_sonoma:  "24dcc5b994f410171e1eaf2f45b032ddec6dd2a41daba5228ca5b247327a5d32"
    sha256 cellar: :any, arm64_ventura: "68298fee2815c22a314f1b121b2ac624cbc3b160831c80a4727f625ac4e98450"
    sha256               sonoma:        "8238e0cbb73ddbeaf854e2d72ebc780a6770960011c4170e33693c33e5d87272"
    sha256               ventura:       "9720311caa80a8b5ca3968337a05e788c051738ac3626c4e879e72f860728963"
    sha256               arm64_linux:   "90be7b01eca8aed744b3db5c82a49be6f2e3cfeb666c8f7c9436855c2044d928"
    sha256               x86_64_linux:  "c161af7b8bd8f281efc7d65c226d812283125c0d7cd3b9ce272c123a7ae5749a"
  end

  head do
    url "https://gitlab.com/oath-toolkit/oath-toolkit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"  => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkgconf" => :build

  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end
