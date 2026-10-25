class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "cb1abddb3100d44ece057a37abfcc100d97920681e3ca94f2e5d8b4e515c027b"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1111e60a568324412f72c9b619e3fed26e17b293d0cb9263bafb46af719e3a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a79ce398aa4ba519db8901991a8bc94fa3451cd07c7d6b85d211675ddf4447a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "683da7c2d7bc6f3730021b66ddc861a32597cc09e00acb09c57a32c07ec3ceac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a8b1c66c805c1b7ae0ceafcc87e76f3c0dec763d7216b9a251fd31081e45b8d"
    sha256 cellar: :any,                 x86_64_linux:      "593e8fe58fab47df94224241460a7c4c2dbb799cc3daab336f4a7881c41945e8"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
