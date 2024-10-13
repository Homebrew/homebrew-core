class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  # NOTE: the livecheck block is a best guess at excluding development versions.
  #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.
  url "https://ftp.isc.org/isc/kea/2.6.1/kea-2.6.1.tar.gz"
  mirror "https://dl.cloudsmith.io/public/isc/kea-2-6/raw/versions/2.6.1/kea-2.6.1.tar.gz"
  sha256 "d2ce14a91c2e248ad2876e29152d647bcc5e433bc68dafad0ee96ec166fcfad1"
  license "MPL-2.0"

  livecheck do
    url "ftp://ftp.isc.org/isc/kea/"
    # Match the final component lazily to avoid matching versions like `1.9.10` as `9.10`.
    regex(/v?(\d+\.\d*[02468](?:\.\d+)+?)$/i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sequoia:  "1c084c993083468c76a0729dfb4b2b231a737fe7323f9f99f6490098cb74f147"
    sha256 arm64_sonoma:   "198b4e13a2d22180c619d3cdd825e06c2ea6deacf1e1e0f1edb4bf8a4f811a56"
    sha256 arm64_ventura:  "dd9a0ee71e6edb0445804e2acdac49e4ac9f14e954c8716f2bccf217b3c42960"
    sha256 arm64_monterey: "4d6ef86f0bc8fd533f67de887f6aa0244fa0199c82fd3f596e8ca7af6616b9fc"
    sha256 sonoma:         "b12c07c7ea8512625d415ac5f90b2acf153f49bd57764a3c173448235906b0ee"
    sha256 ventura:        "d2443974aad0fdc56d03a21795d83e8101928ff0605467ee6055b9939d34ef9d"
    sha256 monterey:       "29c57e487849a00ae7bcf4ee78afade4e64503cb197b63684dbe60777fae4d22"
    sha256 x86_64_linux:   "b45ed2602b200d7f2ea8ccad1a72b9c8362e63766b606edf9ae3ddb5a780abea"
  end

  head do
    url "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"keactrl", "status"
  end
end
