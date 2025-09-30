class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.13.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.13.tar.gz"
  sha256 "5b5d82e9a4455206d24fcbd7ee58bf4c79398a2e67997d80bd45ae927586b18b"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "01c085e9dcf3270fecffca88b5a99935cf75d9de0e2b5c84044bed01df67324f"
    sha256 cellar: :any, arm64_sequoia: "a194b2db6ed6b3566e16a7ae5fbe0493f6e6450676468f774910fe30d83fa199"
    sha256 cellar: :any, arm64_sonoma:  "cf4057a1672ecedade4214940e6fe786b08d403798135dde3c78926c0b1758d2"
    sha256 cellar: :any, arm64_ventura: "7a8fc9a02a185f4adff751b49551c555b104cd1733754b21ee13255b7df1e1f8"
    sha256               sonoma:        "8fa9c96c1fd5491d8316653a396476ebe4a3a03f2f654ae3d9de9e84c2f03d8e"
    sha256               ventura:       "45d3b881643fe9aae507ff2b79135bd8fced496f75c8184a4c8a2b515c3278cb"
    sha256               arm64_linux:   "976d358c400c6ca225db031e9c1d4934d9bf8d84b42dc23caec116dcab283bf1"
    sha256               x86_64_linux:  "64d5b405189368bb048ad03474b44fac7fd76853996906629ffb00fc5b4f11ac"
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
