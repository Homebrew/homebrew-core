class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.3.1/libfabric-2.3.1.tar.bz2"
  sha256 "2e939f17ce4d30a999d0445f741d3055b19dfd894eff70450e23470fe774f35a"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95a4c33f931e82bd48e2e1fcd9add3d24f9bbe61c1f7bcacbacd1c254dddf27d"
    sha256 cellar: :any,                 arm64_sequoia: "ec97df5c70a6884cf6c88a0e7d2cf408b1e1e00511ad2c1ac5524aaac91ae960"
    sha256 cellar: :any,                 arm64_sonoma:  "5f385c500a9e869ee6bdb6b7017f4860fef1b95a4d04dbd271d440c23384711a"
    sha256 cellar: :any,                 sonoma:        "c47dced678c368ac7940ba1dc2d6f3928227c40edae066ad0327460f407b4552"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "186dcab2dc39bcb277855baca363bed33c5bd1e16af661b61def39bef37e56cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88d2c0dd7434c09a8297ac5a6310d2a2a25991ae835e23fdd3fb844b8df288aa"
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
