class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.261.tar.gz"
  sha256 "58f410758703fbfc193a6510e7f1474c705449c97d894dbf1c78acc055caf1a1"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd77c529299a1425e8b37995246cf99bd6b42529f3b0c617ef7100fa73eed0ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6ac29f838d5dba2c6821b492ea3a74361d9279c3f05ae9787bf272b5b77c5a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e4224262b7f36846f1a2bcb44e357506ff2bd21ad69d6f51bc6e446e71158dd"
    sha256 cellar: :any_skip_relocation, ventura:        "fae0f4ae8f78fbd9a91cb24eb318a64849d3890d6ae5bb8a00dc8f71386df3f9"
    sha256 cellar: :any_skip_relocation, monterey:       "0266611d44cc647f0e42fe2825f669635ac2156d0ed0b6d9f6e051e6b2d45f8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2e5acdf54f3b505ff4d8ff8f60af66be4a939cbb1a4b2b803c526cb56a0a332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a76155a0c3db36a02971596eef93703004f8c49cfe2b473b891fa8f1b7f149f"
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
