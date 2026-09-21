class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.7.0/libfabric-2.7.0.tar.bz2"
  sha256 "366000427e194d4ce22e272519b608afbebb1fc9915bcf5da924157a8a47fe10"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "00e9ef43819e45fc51eb7aa874c34a4f19b9e2a258c3d8efb5321e6e18c90ec5"
    sha256 cellar: :any, arm64_tahoe:       "0726305d521d5c6a0eb585bdba78e7812178725f71ebfd8400780f4f08127d98"
    sha256 cellar: :any, arm64_sequoia:     "911320e794efd1ba2bc0fef756838f32fe1311bdc36e783699966aad93fd52c5"
    sha256 cellar: :any, arm64_linux:       "248babb342dff1d36c5f59622c082d9285e77fc35cad484dc8f22a3c67c3ecb0"
    sha256 cellar: :any, x86_64_linux:      "7bf38ed2e48785e7b09e5389cf51a19acf4a368db3bf3b8bfe4cb3a1722041fb"
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
