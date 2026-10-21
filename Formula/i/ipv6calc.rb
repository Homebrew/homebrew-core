class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/refs/tags/4.4.1.tar.gz"
  sha256 "c8227af9f8149304006070bd1e1783e4b1f8abb37f3d34822c7ea82b05154808"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5dad89f5fbfaf81c83848dee0309f654a51079107ea0c76d778a4603d490cf86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f694cc121eabb42e7190973671e9e909012f607a873525712ac71c1d854af0ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47743fe1314cb83fe99bd58d72b38357e083342e0dec123cf5a1fe4c3e8bd001"
    sha256 cellar: :any,                 arm64_linux:       "c6e1b0d2a7e29b5cfc0c5e2b3fe9d85778ece72b3c3f40bc10ccd113ffcaf8fa"
    sha256 cellar: :any,                 x86_64_linux:      "e3c6436e04e7f5e7247fb832c14219edca0ab3f5fbc45f64f0b5aa45b8218fd4"
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
