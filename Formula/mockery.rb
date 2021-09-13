class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.9.2.tar.gz"
  sha256 "a7de4dad9e89922b0e38f86f0a7f8f2bfc4c2c4be41fa3e66178c46964464476"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22e8a91958982cfeb8a03c941380cd499590ce99f109889a013dce7a7314ebe0"
    sha256 cellar: :any_skip_relocation, big_sur:       "0fdcfbdafb9799e0a95b125672121d1cede48148de8fa7b5cff146397f522ded"
    sha256 cellar: :any_skip_relocation, catalina:      "5f5aa7abed60f3c9dab73d9a226a89ec301025560f42ade65faa32f58f3dbac9"
    sha256 cellar: :any_skip_relocation, mojave:        "bded58a35c6135c67ff52878c18ed6ed1e609ae0c40337bbb038d44529362c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6c84237a14f899f577b5238ff3732f86dd87e1618809dd885eeb165b7c3938"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=#{version}", output
  end
end
