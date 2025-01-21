class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.0.0/libfabric-2.0.0.tar.bz2"
  sha256 "1a8e40f1f331d6ee2e9ace518c0088a78c8a838968f8601c2b77fd012a7bf0f5"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46238f5c1c9a0166b74cbc9be48c22ff37ed554b06aaccca1e4227ba7e885ce0"
    sha256 cellar: :any,                 arm64_sonoma:  "f269ca9709004c3083f3a8fbaa3d55ae20e960346aec3668a13e6804cde9281b"
    sha256 cellar: :any,                 arm64_ventura: "bc816ffc5cc3a3b1f1002013cdd5a3a012e5c932ef48e4855bb1313b8cefd550"
    sha256 cellar: :any,                 sonoma:        "ea1fcfbb5f56da802f90ee170dc781904c5971f8c5c11a90c8c46dc5d57d9701"
    sha256 cellar: :any,                 ventura:       "f994b2ea09200f927a6f729cf26d7cd12af8c4a9560914b3fc9f6b6f499b774b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ca9881749547fcbb6853d09deff1d6e1c3329ea49869d3cebb9d36ca57e1d8"
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
