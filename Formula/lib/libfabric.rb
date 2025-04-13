class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.1.0/libfabric-2.1.0.tar.bz2"
  sha256 "97df312779e2d937246d2f46385b700e0958ed796d6fed7aae77e2d18923e19f"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e708bd1fd4cb2bdd0d37d12b73744fdc5878808d4df727aa12a6bc6db5c7d284"
    sha256 cellar: :any,                 arm64_sonoma:  "c47ad07aa226ff618b1efa4f3aec8785af8805f81da91cbf79710a465799949f"
    sha256 cellar: :any,                 arm64_ventura: "744ab1d09613ed90b5daf9ca56f157b0a5be99107e572394622dbd58e10285e3"
    sha256 cellar: :any,                 sonoma:        "cde9e6629221b066db676576f7b6f76250db1a3cb0bf18447eab63d2fb5ae39d"
    sha256 cellar: :any,                 ventura:       "7ff1b4a7c98bc71d9e86b20ecbd042482addef9db83f835e6d77b84fb26a4ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2850f3048c57104572aff425bdc2dc4877612dc6272e0b2ffabb591f298a51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8572d2600655e04cc2e5ed5d09d9e811f6dc79e0e948ec9fc08e470cd3241184"
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
