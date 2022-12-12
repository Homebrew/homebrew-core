class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.187.tar.gz"
  sha256 "e4309acfde0de42b45a5423de61ca5ea49eb8edf2e5a5a14e301a84de9ebad03"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8318c34208083403f620930b6fa3cace3fda6a03d05f13a12e0aeb000ab9faa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70589724dbd1689c537b1ffaad68318a617783dc660113514fded31f018bf3f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44f91fa249fe901fb6cdccfb7f288d636da4ae76289bb979ca58bbe31fe235d3"
    sha256 cellar: :any_skip_relocation, ventura:        "d308bda0b8f0a118f65ee6d1f5a86ed6b697df53ff617b2e8f6fbd77b5ca5f05"
    sha256 cellar: :any_skip_relocation, monterey:       "35b7da3e4b25567c29b7e101a92193a85d35ba5389507c4d51276a6b8c3545b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a9c3a5f61c8a4e558fe5c4f59c1cf3c7a3a3267061635b4f4b754cbd46e99ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc9cff92c514dbcac24beda9c75b1419e9ee6707397a4f3852f4ab9a174b519b"
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
