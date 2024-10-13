class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "52f58d90d5ee9ba562b1c235832c35887275a680ed9b3572d680a38c7a06efce"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "887b43d00680480dca0c25d3f79c1877203931051b666e8f7b93016899560dd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35a474cb27324e398bc7b022b717f7486769186aa813f01107e1426d2a431dbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9072993c2884575441ba51f06eb04b62c3c1ff7370ac757ee21d012ea702e7f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ca0c28bd799203e6e55b73db4bee2bd9eb61f6e26a9eaeea3a7e6e74d1378de"
    sha256 cellar: :any_skip_relocation, ventura:       "36fb546258e2144f2439341de24dce1fda5f2eb9a3be3fa1abd8c03dfceda54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b54e0603d3ad3896b8403ad9e907350a1550132c367ea3a8313c7cce29a2f99a"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
