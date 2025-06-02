class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.310.tar.gz"
  sha256 "d7d8a58878c037372022f0c1d8fa58e15eb3d198498b521332d05def84cff351"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "040bcd8eb795a256abcabd045288da3a641eb82115b610c1050cfe1403689f71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "040bcd8eb795a256abcabd045288da3a641eb82115b610c1050cfe1403689f71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "040bcd8eb795a256abcabd045288da3a641eb82115b610c1050cfe1403689f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "d493d3aa98b9cd85ee1ddbd85c832bff44b965795c197179046520a9187f5775"
    sha256 cellar: :any_skip_relocation, ventura:       "d493d3aa98b9cd85ee1ddbd85c832bff44b965795c197179046520a9187f5775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3caa7e2d6f717e621d7d7a83f3739e07f256951bd963e2c311d4fff9bfbcc0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
