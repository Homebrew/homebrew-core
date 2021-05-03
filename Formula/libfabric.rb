class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.12.1/libfabric-1.12.1.tar.bz2"
  sha256 "db3c8e0a495e6e9da6a7436adab905468aedfbd4579ee3da5232a5c111ba642c"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "576fc78599d5f8f83a21d1181227055b2b7c714d42b23729399241040bfc9c6e"
    sha256 cellar: :any, big_sur:       "a3a811958cc96b20969fac9962aa22e48d9542b9edae5d714a227803afa79db4"
    sha256 cellar: :any, catalina:      "60b69d42dbcaadaabe396a32352b54b003149997f1dfc325d0ec8c101b2fee86"
    sha256 cellar: :any, mojave:        "d4367f6c53c99f49fed8bff092d6e6101bd61e2be6e26893c324d5a2a84a71ce"
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
