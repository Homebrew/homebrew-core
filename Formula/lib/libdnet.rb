class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/ofalk/libdnet"
  url "https://github.com/ofalk/libdnet/archive/libdnet-1.17.0.tar.gz"
  sha256 "6be1ed0763151ede4c9665a403f1c9d974b2ffab2eacdb26b22078e461aae1dc"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/^libdnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df49ba85298b074c807b238f6bd0e4b5a01a383dc5bc176108974e29223f6708"
    sha256 cellar: :any,                 arm64_ventura:  "cc486dc6c49d8e3d794134820b5b6978993461e28fe458f4f95d950aca498c10"
    sha256 cellar: :any,                 arm64_monterey: "dbcaa077c1f422f752f65153081a114ad332627c0a16e58da85d7050d4b9e934"
    sha256 cellar: :any,                 sonoma:         "aa95e2440ac4a1d22e6be37414c8382fa120b247d692479f7169222255cebcec"
    sha256 cellar: :any,                 ventura:        "c5899247c77b22c56e8962e33803c5678a6f30316a134c752d61e072f77d0eb5"
    sha256 cellar: :any,                 monterey:       "de2ccbc4f813008d10f83dd8646119bedac9125ab810ea7261998ede27f7e5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6456598bf880230b79a65d1ba7133e9e594ac547495182afc6e1c70a51770529"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    args = std_configure_args - ["--disable-debug"]
    system "./configure", *args, "--mandir=#{man}", "--disable-check"
    system "make", "install"
  end

  test do
    system "#{bin}/dnet-config", "--version"
  end
end
