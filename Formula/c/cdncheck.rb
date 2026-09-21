class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "ba68bddf7a7ed3b5daa8ace46cb4f57d977c62973a245e02aa8a792a97a80295"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32a10ae8c6629ae3d27d678d9d78cca8822f78df12d4a74f78252c79576e5e07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf51a20c2b047552c90f2bc4de6699ec5dc7713c1e1d7a4eca46f5d5147ee335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d42f910985f6f956d1b5444fe278523b21b37ae0e349cfaa04aeaffb45caa75e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5af02e0fc875d168c006812b48ea82ff5abf2b7c7a18b990c1a362a33f231926"
    sha256 cellar: :any,                 x86_64_linux:      "e67937b7c44192b449cf46ba482dcee98d2144b2485d09a86fdb751b9ac7a1fa"
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
