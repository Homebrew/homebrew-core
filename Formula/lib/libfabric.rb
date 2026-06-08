class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.5.1/libfabric-2.5.1.tar.bz2"
  sha256 "ac34788a52b3e4a3a1ef712ec29bc4261c63dfbd9e5e4d6e202a0c3687be368d"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0024a4b494c4e3d9faf169cfaf2b54731e04f5ce55a8437dda4f65ba4708a744"
    sha256 cellar: :any,                 arm64_sequoia: "62c444eed0e93afe6728eeebbaa267eeb1635420f94da75c6f55f2800c64b86f"
    sha256 cellar: :any,                 arm64_sonoma:  "b033948b9f2f49338e754f5b60027baae361ebb4ab684a9ade76df5c41cdc139"
    sha256 cellar: :any,                 sonoma:        "f65db186fc2dc198706755b2a7c96ff998756b22f1c9135ab168a47589b9a4a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae797cfbcc6935530c8e42a7acb3ff4d7f8ff144a71b3554293190fcaf4f3638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d466a23b9207ec21d04354ee3a81b832bd0ccbe7ec38b812ce3606ac03eadb9c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
