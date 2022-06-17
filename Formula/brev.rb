class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.75.tar.gz"
  sha256 "03aa9c401adff82a4ca7cc7a9414cf06f76918e196d7b62a9e75bd8a476b33ed"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1821606542157b0bda66c18a0e069a9a91dde57181614d022a541d4172d79f26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c55b4eb9f88cab49e1c1475634959d9dc5634fcd700ec9fe01fd40b157bed494"
    sha256 cellar: :any_skip_relocation, monterey:       "df5bab74bc44e34e695c9f395218444bf979dcf53facb72d466efd1ecaf55ae1"
    sha256 cellar: :any_skip_relocation, big_sur:        "65f4a0e33b30d608ed99e8c1f673b5bfadd618986ea72426284c5b814b5ffe9f"
    sha256 cellar: :any_skip_relocation, catalina:       "5074bdbb0a74303037c0ff9fe21d49a8954bde9ac35618dbc45d9058d6730f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "170b1625036099a7841fc3402be12463491165cd00688256a4b68030555a9b3a"
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
