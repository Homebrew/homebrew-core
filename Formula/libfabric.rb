class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.17.1/libfabric-1.17.1.tar.bz2"
  sha256 "8b372ddb3f46784c53fdad50a701a6eb0e661239aee45a42169afbedf3644035"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "737e01072dcc9314ee18c5a0f796d9165f74d5f12ed057090351fdd99bd0d252"
    sha256 cellar: :any,                 arm64_monterey: "727670167d62dbffe153cfa2fdae9e09308b634f11430e84db8ac7fe58140b08"
    sha256 cellar: :any,                 arm64_big_sur:  "458f9631e41e1277c5e0b5f7ecf312e30b75cc8fa933a20c375df1860a4c7427"
    sha256 cellar: :any,                 ventura:        "6a243774b64240decdfadccfb0e7a03a580ef9004da20463e819be71ae998ae8"
    sha256 cellar: :any,                 monterey:       "bc408aea6e0b39676bec692e88702cb053f8abb66ecd8510a7074fcdc4ffe561"
    sha256 cellar: :any,                 big_sur:        "7f2d5e0cac80ab0fae7cd88f4c475e15b6ecb033cb1d597e3fcaef744bbaff97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d7492d1457a8550626beb1ef5456033d836ccbbe8dbc3ac892d7f67767cae22"
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
