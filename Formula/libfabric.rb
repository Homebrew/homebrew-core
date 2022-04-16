class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.14.1/libfabric-1.14.1.tar.bz2"
  sha256 "6cfabb94bca8e419d9015212506f5a367d077c5b11e94b9f57997ec6ca3d8aed"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d940a430c5b1d773851e425239fc924155f08fab327a46c5c60cec3d5bb538d3"
    sha256 cellar: :any,                 arm64_big_sur:  "6c0148c987d5d86eb54c790e7bc528bd0b744c2ae4b4ac34af3ef8d67a731e72"
    sha256 cellar: :any,                 monterey:       "de6acfe3a9f224363d3995b7e895b2017a78d4249ceff84be4a44b4f3a08e433"
    sha256 cellar: :any,                 big_sur:        "40b80728c6b9925662a5e488a187c50d7f9aeab33e65cda017f6fa8afa57745e"
    sha256 cellar: :any,                 catalina:       "7f1af2e9f62d3460dc39db7b2d5cb1bb6490fb6fe7f7fef5d9c52938b2e13c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd8c220a845d899c34e53bcfb4e6fe49201138b8c4161ed0201b1fd4cbbc6540"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
