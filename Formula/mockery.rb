class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.13.1.tar.gz"
  sha256 "e52ca8bfa6b6f9bfb90d42e9e065ef01484f8039731cc320f6dfe4b11fae76b9"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cfb1c3192654e3e6b69ea029d505b55d33219dd8e45684594b03cb72a0aabfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a4025c3f0ae2f2b44f79438f0a5c4b0cf9cecd087897ec772699e5d0c71b331"
    sha256 cellar: :any_skip_relocation, monterey:       "f08f61dc343829b7c88cd1ef9642e88ab1de40b8c6a788f11b26a93010348358"
    sha256 cellar: :any_skip_relocation, big_sur:        "9369edad2e50e18f7b942312006e23906ad003e2b545034efc09365294c5c2e9"
    sha256 cellar: :any_skip_relocation, catalina:       "e8f829c1e896b5505c4590846125d34ac3c257e1dcb5d0c6302723bedc96f30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcbc3ade3a91c2cc4e2a73088a8b549a49892e2cceedaf57db5e636bbafc737d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
