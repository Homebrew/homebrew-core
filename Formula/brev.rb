class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.253.tar.gz"
  sha256 "37cd165800438b1ca9605d1241cb8a25a18b5eee3b71b916e38cdd5c87f9f2f6"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79679ddf3aa740fc5610574ff2da4e36185c66f6a11460c250f9d13ed63294dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dab0ae7fbf626de33bdf9d52639171a6980a2d0badfabadd7155141b83ebe359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f38fbed349106945a79a111f7e86f8d65c383994dd72d78d955c544a2a94f1bd"
    sha256 cellar: :any_skip_relocation, ventura:        "96282d6cb8a201aa2d4e2fe374f73ce9b02f7eea87c02b56fd1561aa8a46211a"
    sha256 cellar: :any_skip_relocation, monterey:       "be57e2c073d98f37720f1c4ce38e6bdc9a0ca5b434f131e553a8dfbf5b810a86"
    sha256 cellar: :any_skip_relocation, big_sur:        "e18a5471a38eec89791b94869883eae95a685e6dfdedd8a9ad9b6bd85a441070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9658daa67b02c2fe7e3848900aa8958e6ea07c211e4130a77df29ed2ee371b0"
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
