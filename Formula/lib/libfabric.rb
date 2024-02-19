class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.20.1/libfabric-1.20.1.tar.bz2"
  sha256 "fd88d65c3139865d42a6eded24e121aadabd6373239cef42b76f28630d6eed76"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "710f5b05643c3deadee21a01a8c89cd2f427c8c66a041384a7c0310f1035117e"
    sha256 cellar: :any,                 arm64_ventura:  "2a869633a5678b2b0a51be36326ae9bfe84462fd530665dfce1ebc63d1084b37"
    sha256 cellar: :any,                 arm64_monterey: "9710a1a6b30fef294b5cc93328295933ff847b8929e595252dd886c54ea06d30"
    sha256 cellar: :any,                 sonoma:         "e800910ff8977962a242437a293e193af216920381824e9c4ef7d3354072ec34"
    sha256 cellar: :any,                 ventura:        "c1617ac7e230b773941eb45856bd9fc1964c8be30f58cebc883d27b6d2efdbf9"
    sha256 cellar: :any,                 monterey:       "d25063f79b598797259495da5f00af156fa09ac3cb86c2fe4dc2fe2a16172bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea109bb49a284bdd71eefa830d4f9ec20e663f21c537eaa055ea0f17621be87b"
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
