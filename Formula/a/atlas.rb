class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "70c0efefa3605279c8eb6fb69447b461f304a6846205d23d394570fc4cd95d69"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34207701799315abfe7a888cde24f2b86fe5b5fa5ff75e3382c130b0674756d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7a3e90c2446f3e7a1c99f328624950f79b5a2278d78133ed33088a7af35f84e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "465d79753381fe25c1d707e76a979a2635b532c01cffdeeac45976cb18d4f28a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e07364e03dbdbbd95c0c6c8d1e4091aab6ffecf200dbac35d72e3584c89e956a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b764d1659b61f6d095290397af53d4f8ac35795fa4322abaf25d14de84f365bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1822b313630f1c80e9c10e48d2d6ab4b0be616a1d4d3bc60c04642e91f3090ad"
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
