class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.4.0/libfabric-2.4.0.tar.bz2"
  sha256 "13f508e1d770c44f872c4117d9bcbfc102dc9d7532d3292455e0e0e5ef7b3bba"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4dd3b1dce713f5db21167eac9632e6a42c70ccce828f7249b11fdef8474e3eb1"
    sha256 cellar: :any,                 arm64_sequoia: "20636cb6c553f8344681b7da625fc6f1f5af447d73adc9223e60edc22a8e900e"
    sha256 cellar: :any,                 arm64_sonoma:  "bcbd780a01b02da314362c6f0884df0a5225700a42107167f5cda1f9cba8c90c"
    sha256 cellar: :any,                 sonoma:        "927414d499184088c24ef2833691ea0d26b1386f51f2c4fda28d9c8b52835bac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3832559b56f2b8d6e194790a11e3e80fc464cb2980f94ce39f1f099736fab38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751b31b5c57276c8ea427511b08540fec3171463e319c68b2523758ab0057064"
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
