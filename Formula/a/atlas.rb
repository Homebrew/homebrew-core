class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "2710bda0aaf95df0ae896bf9124e97f407ee5f3bda22855999fbb367748b87fc"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06f432355f0852bb52a1976e2a29a56266261026ef893699b546d17d8ee001b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4df078fa60b9e08701e6c00d835493ad5c5812e9fadab12ddfa4dc4e59b0adf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "def6d7acac6f02814561e04c87eec113b0e7444d990cbadba6d5e69c8bc322e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "21ff99edc4d8b0911c94ca494a2d7f0f96da9f9087bbd7f1b9a265644c46a0f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbec5d4f6ae8e5f30dc18615148bb221c737565146b870672957ab946b573dcf"
    sha256 cellar: :any,                 x86_64_linux:  "059ad3c3a453b06683573b7c070d9ded1ce915c0e0b5bb0f0a95573d38890c2a"
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

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
