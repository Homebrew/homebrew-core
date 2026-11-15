class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://docs.projectdiscovery.io/tools/naabu/overview"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "6eee1b4b4c9b4b5eb19f175c2ac67e04babc6290f937b9c72fca0b1183e3fe47"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43eaf2ff0a6310150d63af7f0cdff1ca2827347707391956b42d69ab674a3cff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e12d1745a05845af476aba7e0d9c7c49fe57872c81564cce1c312976722b8e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2443dc47eea700044e9c0a02eb09c2bad20388bf8d5dcbe17abf83265cc31600"
    sha256 cellar: :any,                 arm64_linux:       "9234f71b59a2a79453b47dd23549236f6f81ad715466bfcc4353fa506e6cd5f9"
    sha256 cellar: :any,                 x86_64_linux:      "ae2a47bdb85536670cd643a5aa1eae5bb9a8daaa198a37e6c8a4c78ec4daa5cf"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args, "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
