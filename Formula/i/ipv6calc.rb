class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/refs/tags/4.2.1.tar.gz"
  sha256 "49ed6995a3fdc680d45d6cfdcb613477feef071d2f791cee72ead5a7744eea85"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6854927b5bc7b18fbbc2ce526b978f810d3840fd19781254f4a8f2f068e5d135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efc2d877e4e9802105c46b0573082df300be4cdb0ba15f8f39dc9782267a2d0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dbaaea9720b9f9a89f237c1148f757ba8ee45e3aa87bdfc693307b15f88c971"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e4bb76c43ffbf095f46999a8b4db50ebe6a1c6619c9eadb79a2914a788262ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "6178b1f1ccbe61eb6b6789e8f65e835ebbe3d4664c1d395a031e092bc4521b4c"
    sha256 cellar: :any_skip_relocation, ventura:        "d6b432b89c69d947a609688f2819572d2eb0396b205906466032655ba93bfcf3"
    sha256 cellar: :any_skip_relocation, monterey:       "3da5205804fabd86e7bb9aa3dacaaef90bc90fe116c5e7748c65bc2c7ed77f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89069ec93737f3755f54de8a6e8304d96e59be4ddc5adedd0f841aefe19ea62a"
  end

  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
