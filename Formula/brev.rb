class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.19.tar.gz"
  sha256 "ff6fd0afa4debad5cac190519a5cef250246df8cddfb84dc2d5bc40c2624d36d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d732c702146aaf8051af9ba645a8970271ee642661c03a6a71e122513fba2f80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "077cbf039b9acfe07079ea320a82a5cde3a8900bde23c5dd06926e96657af8e8"
    sha256 cellar: :any_skip_relocation, monterey:       "aea80c588e3a33ce1b7c34e1218ca2f544ecb93104eba3d24744012320a81d16"
    sha256 cellar: :any_skip_relocation, big_sur:        "8300ba659d22517e8f2652bd923592744e30bf8b8b18ffd2c2a130069c03556b"
    sha256 cellar: :any_skip_relocation, catalina:       "dba61d4bd987794c90fc8b008f343c063cf510607d3837dd42106f04d9ee1c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be3e2a159775f9ef1a2d7afe96178a356d6074620411c44a3992d166d4987e95"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
