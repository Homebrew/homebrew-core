class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.13.1/libfabric-1.13.1.tar.bz2"
  sha256 "b8b5e1dd875d9db37087487e30f4b0e2d86b9f928755225ed92960ef0f4e1ae4"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0faf8640e81769c91fd533040fedba6e38e979a078a6feaac88595543eb121e6"
    sha256 cellar: :any,                 big_sur:       "d36c230c17834a53d4427bc26cc982c7575595707d7a2179e629f81cbc661951"
    sha256 cellar: :any,                 catalina:      "5ac8f1202e3558aad6f83fa085e9e384546e5d54cfbadd600d35ea1fecf630af"
    sha256 cellar: :any,                 mojave:        "adedf2375e16169127c2caffe63e7df5f13d739301b929150779ad3a30faacb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c0448c0eb7155e04bb6771bc9981b0e50f86cb1cb39bcaa10540b303ead891"
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
