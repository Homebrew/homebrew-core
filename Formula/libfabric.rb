class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.18.0/libfabric-1.18.0.tar.bz2"
  sha256 "912fb7c7b3cf2a91140520962b004a1c5d2f39184adbbd98ae5919b0178afd43"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "454894e88adef6842e23fff78c58dd5b62b033fd53483c551840e6a6845cd72a"
    sha256 cellar: :any,                 arm64_monterey: "656cb5710bee31760a723a25b533c2dd6b87be0bee89b100e22ca923bc2729d1"
    sha256 cellar: :any,                 arm64_big_sur:  "2e5c0658f4d7e7c2924f20f9c2cfb4dc96484692dc107ef2b6da6ca4a27ab814"
    sha256 cellar: :any,                 ventura:        "8deccb16f742d5e4cd52d2101c043c3473351b3f885ee46607efb7263c9befc0"
    sha256 cellar: :any,                 monterey:       "245b2cc95f113d224bb286acfb7286486b9340168fe8d763c96fbda46223add7"
    sha256 cellar: :any,                 big_sur:        "7a3c7f0095e87164ec107f4fe75268a9d90382e66e865bdf4b64fd1a78eef361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc6186cd77da43e665a70c4ca0f890ff3524c0193602c441869cea8488f1c15"
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
