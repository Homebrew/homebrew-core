class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.13.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.13.tar.gz"
  sha256 "5b5d82e9a4455206d24fcbd7ee58bf4c79398a2e67997d80bd45ae927586b18b"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "49c74a2b634c5656da1dbc1e8f611619d41c9d14e40178c09e0d00896bab242e"
    sha256 cellar: :any, arm64_sequoia: "883602908ae3413d7f7a8c9fb563e2c0a43733b94a2f7e29c34e297774d6f981"
    sha256 cellar: :any, arm64_sonoma:  "1326ac22546cde2d3f61daeec243129c369a085d760231214ac796b350295c86"
    sha256               sonoma:        "67b72f23e1f876bba4b98b4f69fdbb2034caec6ce11dde9ad42f52f97bb773f6"
    sha256               arm64_linux:   "f66209c876693a77907889efe837c136174c768d958e4b7946bc98324e2eb1de"
    sha256               x86_64_linux:  "1e825b733079a0d317fe81b037b64c4e049a0bb18bfb5b60d25b4d66b46af55e"
  end

  head do
    url "https://gitlab.com/oath-toolkit/oath-toolkit.git", branch: "main"

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
