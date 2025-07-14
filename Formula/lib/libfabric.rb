class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.2.0/libfabric-2.2.0.tar.bz2"
  sha256 "ff6d05240b4a9753bb3d1eaf962f5a06205038df5142374a6ef40f931bb55ecc"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df57c2e528f8a26eb5da8d417439b0db0ffc59e7627d87e599563be6054e1f3b"
    sha256 cellar: :any,                 arm64_sonoma:  "7bfcb4c41c4be00209ac13bc4110a846133465c66be65d081b985b02ce7e1393"
    sha256 cellar: :any,                 arm64_ventura: "da5fce00ddacdfa6d750e5cf0f16ca2e9bb78ed06b5e65d2e41828abd7de88ee"
    sha256 cellar: :any,                 sonoma:        "d309cda13f5c7db8a49eeb750962205b70db951215eb445da9e70d00c05bc215"
    sha256 cellar: :any,                 ventura:       "98f165b0a7baaf62924589fbb1abf2f8be1ec5c0cbad366118adf7fd0fc528d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b537675d192838a46cd11ee2c6286e4256b4de22b6d5b3597da3d165d29d97d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d4b6fe203266b16424cd7aca3bc54bccfe66125d679310602e6eea2103cb4c5"
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
