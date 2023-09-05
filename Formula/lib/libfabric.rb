class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.19.0/libfabric-1.19.0.tar.bz2"
  sha256 "f14c764be9103e80c46223bde66e530e5954cb28b3835b57c8e728479603ef9e"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eb0faceafd65334ff43eaa02448c4c8e07bcb4affcf445e3e3413c02bdab390c"
    sha256 cellar: :any,                 arm64_monterey: "71214b099398ca483bfd588b994ead5de4c72b07dcba20d779f599fcca1a511b"
    sha256 cellar: :any,                 arm64_big_sur:  "f881623b1bbede6a70a13770d396065f5b793885893a0762979a92874adbe34a"
    sha256 cellar: :any,                 ventura:        "95105d9e4f9845836fb80e26be459988daf00ed9ad6228f2fccf4dc2865afe8f"
    sha256 cellar: :any,                 monterey:       "ca6e9d5a5a50849ccaa2505c448e16952e7612c8106c5fcb2b595b232c0adcc7"
    sha256 cellar: :any,                 big_sur:        "95d6fd224569b8104d11373cdb536a523b8ad166dc0675be20fa4f6476bbaefb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37dec84fcb8532f7017c04bcda2448b47e5cddef8e5293d19508ba929155ac89"
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
