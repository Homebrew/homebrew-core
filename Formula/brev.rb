class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.71.tar.gz"
  sha256 "c1b6633ff03870fb62a0a86ad1cd31c0af04cb17cd6744c972a3bc4637e7d2f5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70a15a03424c7325107bd85a86c440101980223100912bfc968a66549629a244"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddbf2fae10b46c38be72dc03a438b8649f530ba9cab8d8382b9d8a97338ca50f"
    sha256 cellar: :any_skip_relocation, monterey:       "baab03a831b2363d2f8e7f6984f7ce8231bd4700d92be75650ee4e4e9819219a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb614a01cee1ed46987bf6ab28150a17cdcde3164bc5cfd2e8da63ad8478fa33"
    sha256 cellar: :any_skip_relocation, catalina:       "4878b67169e0e74d38f9a7c1132fae9151fc9c31e739b99ba63f1edf0bf554e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c50dd93cfd3d91a927e6f050c9750a401aeaf661b341fe9d13c7c84685c2a879"
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
