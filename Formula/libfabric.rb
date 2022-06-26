class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.15.1/libfabric-1.15.1.tar.bz2"
  sha256 "cafa3005a9dc86064de179b0af4798ad30b46b2f862fe0268db03d13943e10cd"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4ec2879d4e59932f371eeded1eb79f0d332b69300b8fb92da0ac5dd6657ac15c"
    sha256 cellar: :any,                 arm64_big_sur:  "5b02b095816fb64890a7ce0ed1e6ba9facee73af9d36b9acfeec7a4d944e9b58"
    sha256 cellar: :any,                 monterey:       "0b6595dc9b66cb9fdb1cc68549921364f9802b748f8121d16a7fbfaef1f8060d"
    sha256 cellar: :any,                 big_sur:        "f0d68642c119986c6ec4adecda4fb740481e9182687888d5d3a7625c567491c9"
    sha256 cellar: :any,                 catalina:       "835b225e92d2e42b2b6f5e1afa45d3befa07b4a847a4891116fdd2aa8a2b5f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a65daa2e7509cffcbef63dbe18b46f13883c68a92d1e2d458c7603620a251e9"
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
