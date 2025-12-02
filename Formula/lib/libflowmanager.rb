class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "https://github.com/LibtraceTeam/libflowmanager"
  url "https://github.com/LibtraceTeam/libflowmanager/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ab60c9c9611488e51c14b6e3870f91a191236dced12f0ed16a58cdd2c08ee74f"
  license "LGPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "f13149f2c98c93aefc337e29981ccf5a09d48abb58cfbb90763fd9fbc0d32216"
    sha256 cellar: :any,                 arm64_sequoia:  "4d11252d0bcaa2587f52e22e4ac3eb28c2115c7204aaf31594e542b2152bc3ef"
    sha256 cellar: :any,                 arm64_sonoma:   "3d90d67b16c2dbff2d04c17f234e4b4eba726191a60a284e5b1f5b4718a00570"
    sha256 cellar: :any,                 arm64_ventura:  "580edce84318af1d6c9a1fb34e131b54ee82c9f8c949f3fa1e314b240d44f514"
    sha256 cellar: :any,                 arm64_monterey: "a86cc22af11e7199cbdd65a190fb6621b816bf5b01c0e9e6d3cd9f69fa190656"
    sha256 cellar: :any,                 arm64_big_sur:  "85deb8a52e3eb34eaefa5851c1017f77cbad2767968dbb22dc434f1dfba03766"
    sha256 cellar: :any,                 sonoma:         "8cfa25c922ff04f9012e8f41683f69a94907d37a9d183ec734c49554a512df3a"
    sha256 cellar: :any,                 ventura:        "db47efecc48ea69795a1ee1317217d63825d25678ab8a25fdb5da6bd7daa043d"
    sha256 cellar: :any,                 monterey:       "55a184421e4903a2de88d74bfbb7dc46dcdb649778f01ce7e13b1315d8803279"
    sha256 cellar: :any,                 big_sur:        "cb56969ba9c9417ca57ea914fd33358260cdec432b7fae979cfbde80d27ad3bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "90b6a7d18fac55711aeaa7c43caa493db1684451a2d89d2694b8b4fca2b84a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "447c6ca7a8d3774ddc4e5adcb21b9735aff22be9287bb6fbd054e7cd95063286"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libtrace"

  # Fix: tcp_reorder.c:74:30: error: ‘UINT32_MAX’ undeclared (first use in this function)
  # Remove in the next release
  patch do
    url "https://github.com/LibtraceTeam/libflowmanager/commit/a60a04a3b4a12faf48854b34908f9db0c4f080b0.patch?full_index=1"
    sha256 "15d93f863374eff428c69e6e1733bdc861c831714f8d7d7c1323ebf1b9ba9a4c"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
