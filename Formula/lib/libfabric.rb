class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.5.0/libfabric-2.5.0.tar.bz2"
  sha256 "276019edca708dc0569cf3064a412e395ba7b1883299781caed120594f850995"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1eb0057e663c8af7421591234897c10c74d79710f723abb192597bdc998cf47"
    sha256 cellar: :any,                 arm64_sequoia: "0fe138a7dc7caa903e23eb5988a71dcba1182795e41db8523b607cde4a4a61cf"
    sha256 cellar: :any,                 arm64_sonoma:  "9be8a61f9317ba1552f4eebde4e8f8d6aaadb991cf9a62783df71a3f8b380bb6"
    sha256 cellar: :any,                 sonoma:        "03287e12855e2ddcd1a40875d5a5d10b59806a4f2c22d02b3cf57f2d30a456af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d50bd3884ecc069218225496a277cb383e5921dc11e02152dd27e3655a4fd7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30debe7328f7ee2392e18eab9425c12553e90768cf89d698ff9b525bfbc5c133"
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
