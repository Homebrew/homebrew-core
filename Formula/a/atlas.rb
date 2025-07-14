class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "b87b0a1bfbbf0ada21ac691054efcb167490c44c27de7c4bd3f2a1fe7a0b68ad"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bb12c5c19355ece21e7dca0c95adec69db80e7782945e1c3928e2fe3ad1e139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4fde81b21af39bc73a7347e65b0fcfece6d0a68baf1aeca87254bc5c82e3322"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0bfa9434af42ff756fc4b91d523252f88257a8b811f14917aae522e8bff20ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "048a573cf9b37573d51168b968b98eca2fe1e4961cac002c4e1a924464d8edad"
    sha256 cellar: :any_skip_relocation, ventura:       "29df4fa90f43b3312930356c97f40141cc7d3251bc5d0cfc7d5e85311450fc61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6de8c4c8fee6fc85becea4ed44b14419a2efc3c5adbde6f329b7cb93a831035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed973f5f525cb4db1feed2c78f0e082b4a6f8c13b24ad3f5f4fd17d725899af1"
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
