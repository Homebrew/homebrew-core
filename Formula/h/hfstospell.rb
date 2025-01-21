class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.4/hfst-ospell-0.5.4.tar.bz2"
  sha256 "ab644c802f813a06a406656c3a873d31f6a999e13cafc9df68b03e76714eae0e"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a5abc098f35bafed06807e2a6fcb5d9628ec031082e574752c6b94b897d93ca"
    sha256 cellar: :any,                 arm64_sonoma:  "f4f59fbdc8ac56b4a9875ecae70904099b5e6967cab2353d01faee5e14b2278b"
    sha256 cellar: :any,                 arm64_ventura: "54090c096a5b65d691da0b9eeae97761fe51a65e5d667189309e0987ab429ea8"
    sha256 cellar: :any,                 sonoma:        "4afb0aec6411f6d48112f5150c18a996f32421f6f989b1f26f8be7d1a37593eb"
    sha256 cellar: :any,                 ventura:       "caac1fea5a7b3fe47e8cafd75347fe19838af7f23535d9dfe67aedffb20c21a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc01d70da2bb94ee86ae40f49fe5f2d49649b3d2f0e697f184442569d63569e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@76"
  depends_on "libarchive"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", "--without-libxmlpp", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"hfst-ospell", "--version"
  end
end
