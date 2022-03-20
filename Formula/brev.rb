class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.31.tar.gz"
  sha256 "8a35a4cab8800a39ba838e39ddc3e63460b0529635fef01bc396d7c754f17dcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8db4d87faccb485578a9555499f899d12d7883b3c3b2a9b0a8cdff901ea3638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50c8707e5520662bef81bd72b15fa38e30edcc4482b16deae5585d614430a196"
    sha256 cellar: :any_skip_relocation, monterey:       "0fa7ed79102c4697c6ffd977c6b9f8368a5e57f37d866370fb15f608807eb700"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba72a33abba9daa01d1e2ed4ef8e8a969f94f301133a13295bba24cc178f3409"
    sha256 cellar: :any_skip_relocation, catalina:       "77c3b0a9c7fa1db2cdeeff9b9d29c8e9c9c7b8d81d811646854ff4285eb190a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63ef257d488a1d6c08fbbf34b24d1f2f1111cd834c1d83d45101bb778a060192"
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
