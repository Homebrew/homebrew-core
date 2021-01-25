class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.11.2/libfabric-1.11.2.tar.bz2"
  sha256 "ff2ba821b55a54855d327e6f6fb8a14312c9c9ca7c873525b6a246d8f974d7da"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "5dd6c6578f4bb9224fa73ad81f5d07dd68008b24e04386ce127dd710e77c1ae8" => :big_sur
    sha256 "1e4f77732701e2e9447946cf8c5b21d18e7d492e4ca4ea8ffd228ef2abd38769" => :arm64_big_sur
    sha256 "30fc5ea60288a77108367cb3d4e1c3261c5ab2428851b3d3b26fefd5aca9fd92" => :catalina
    sha256 "e888eb40e936a133257bdcd72db23180ce05ddf0093490d07eb8a186d2840e8c" => :mojave
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
