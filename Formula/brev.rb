class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.209.tar.gz"
  sha256 "032793eb669941c2c516aef455f5cab791d0570a3e1acdaa647f8bb98a714f3d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1d92bb8589d8dc1baa1243d1be8c76e2451f83f622b11c87d3828831621ae58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95b8690e70e76d4fd2344aa9af6af916d152f0de0e8346dac9dc6b2b524ffcc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "464dabb2d616abe0bea5b351fe3931e73d4532bd36f2747f7a993693b4725e28"
    sha256 cellar: :any_skip_relocation, ventura:        "a615a49dc85b0d01b583bb47b12065174431fd2d9d2eabadad42ecb70186224e"
    sha256 cellar: :any_skip_relocation, monterey:       "1711bc28d676d9e1f7b7dbce51167e0d98379b7339141a3db5d8af379f5f9a43"
    sha256 cellar: :any_skip_relocation, big_sur:        "f054e90cddb5ec11e99b5861edc5116a36080c83a3102ed4652bd54bd0476720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06404d361af4683a8c32641f51139277e46bda5cb9f0e3be6def1a8bdc8c403a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
