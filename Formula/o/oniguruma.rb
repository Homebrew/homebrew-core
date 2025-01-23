class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.10/onig-6.9.10.tar.gz"
  sha256 "2a5cfc5ae259e4e97f86b68dfffc152cdaffe94e2060b770cb827238d769fc05"
  license "BSD-2-Clause"
  head "https://github.com/kkos/oniguruma.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-](?:mark|rev)\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d6ab71fff646664b91e8ff91744696ec775357787dbc1a28e45d52759662e8d"
    sha256 cellar: :any,                 arm64_sonoma:  "86beadf2205c134bfc642be07b663476532c10591743461c2c64bc85be51afc8"
    sha256 cellar: :any,                 arm64_ventura: "b0c3bbabe91edecb282b400150f05ba77360b5ea0a5950df70f0ae53b79d3d68"
    sha256 cellar: :any,                 sonoma:        "174fa500f45c9421915e22c34f51abc2849cbce2c05b64f013e4949bf2edd7e0"
    sha256 cellar: :any,                 ventura:       "38ea1c89b9e4fe235788557ce0eaa3812d5287c66b217fe798a95f436c241918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49eb885ab9a80ce30edc0aaa5f531fc0079a17e5cf41c2b6c34be0e53e763993"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
