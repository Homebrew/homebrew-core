class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.90.tar.gz"
  sha256 "d6299cf97611d56d022e6cf7504480b4fe3cfb8c40c3f7540483e59c879fc0b6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9f0d9e216d0fb48ac33797035487757d30d218f3f3e72b445f199dd9bccff76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f99542bbbba53cac39c57f8f46c5e22ddb93e13342e3d51934fba7bae7f5c9a"
    sha256 cellar: :any_skip_relocation, monterey:       "f71c98126388e5a1675d0e6a2216da51f7a0224101000e1e14bcdabbc8cd2931"
    sha256 cellar: :any_skip_relocation, big_sur:        "a240f896349e41e50a8539dea808253ed99885aa650af330f89f401a4e0b9ecc"
    sha256 cellar: :any_skip_relocation, catalina:       "29a4b9d7a2061bfa3cc8f59906c70b878f9ef4f9d7ddf65585864471ec76c303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1903f0f640b60a813d92ae1de93f7c42c55a613fd71f1d5c6762e6fd583fcac7"
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
