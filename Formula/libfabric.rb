class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.13.2/libfabric-1.13.2.tar.bz2"
  sha256 "25d783b0722a8df8fe61c1de75fafca684c5fe520303180f26f0ad6409cfc0b9"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "181fabdf6650f07df972fd7646a2338df205caba1e4570ee015ec7d8c3e8cc4d"
    sha256 cellar: :any,                 arm64_big_sur:  "bd12f887e69feb0d822548cd00513bf3c6f1deca980450167912de5a82d05d04"
    sha256 cellar: :any,                 monterey:       "7780a4ec9b6a848f71f34ab5f4b115d40699b21dc3290154b2ca3e541ec5ed9b"
    sha256 cellar: :any,                 big_sur:        "1ba57fdc46168a0efe00066968391d6e6b4252739b671c33579d72c3ab0b60c0"
    sha256 cellar: :any,                 catalina:       "5fdee3dbf08a66e8ae441c9c8393647335f38598ed824aa8281815e0e0d90562"
    sha256 cellar: :any,                 mojave:         "35c8ded08490e8062356671eea1aaa1dfae0889c3fdabc182960aa7fc694811b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f16a95754689f3d59b7b8e62e5755b11e9cc4dc5d4dff98c8409e8141e2ffa24"
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
