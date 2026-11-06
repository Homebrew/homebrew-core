class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/refs/tags/20261106.tar.gz"
  sha256 "1b354fe6fa0089a959ef912085e7a064236d15a7d3c9e6ce86456c3b87d3f464"
  license "SMLNJ"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51eca89676822cd75a52f56835af91a404dd0dd27fed0e3ace1db3cc94fad2eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b93f9eeeee4d904d12c6175f4195551b098c1a9063030e602107d4ab6bd80359"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8312fd473efaa88c7553e68cdfc67e6644685ff7d30f0ea4d84b4704a473c3a1"
    sha256 cellar: :any,                 arm64_linux:       "b2a92fafe75c38e4deb38b350e847919be7fa3b31b64afe31f8e4e13abb7c9a6"
    sha256 cellar: :any,                 x86_64_linux:      "64d3733d6bc965e101f2a26d87ad42866b309615d426e80913dc778a87018aa0"
  end

  uses_from_macos "bison" => :build

  on_linux do
    conflicts_with "gawk", because: "both install an `awk` executable"
  end

  deny_network_access!

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test", 0)
  end
end
