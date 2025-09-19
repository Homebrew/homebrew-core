class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.3.0/libfabric-2.3.0.tar.bz2"
  sha256 "1d18fce868f8fef68b42fccd1f5df2555369739e8cb7c148532a0529a308eb09"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e6d18f0cf616370a77148ef9bc5763de06f8272e2fe7cd0ea9615df1bf9df38"
    sha256 cellar: :any,                 arm64_sequoia: "897e92441a0b1759b9bc3bd7e37e0108d86ed5fbc76efe8f6b7042d848e3563c"
    sha256 cellar: :any,                 arm64_sonoma:  "4d5ca6b7ec48cb3cf7cd17b962bb5198cfbdea09da6576ad2038f4274725482a"
    sha256 cellar: :any,                 sonoma:        "f3075b3ae5b8a1dcdb8dc20b6ad5b8e021056643dc63a7f7b8b04b7e19601ab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "027a9371a19aed6edbab64273ace325df3dd6960c86cfe3eb2bb3adeaae8ae89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a605a17dbbfb098c12c9379c49215d7f72868db0646972cc8ca650c5b8355c7"
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
