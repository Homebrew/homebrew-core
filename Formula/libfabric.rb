class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.11.0/libfabric-1.11.0.tar.bz2"
  sha256 "9938abf628e7ea8dcf60a94a4b62d499fbc0dbc6733478b6db2e6a373c80d58f"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "d047686dc7106ed11356b129ab9a74c9be527551ee781801cb4ebc4288b02c50" => :catalina
    sha256 "7bddb85b8f8ad04ef4e0bd069e5c5674ca5b660ea7932917a572210e7954331d" => :mojave
    sha256 "f697a792adf4b35b20f495da6eec5c173bece311e7b9efb8d59d59a73ded2a9e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

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
