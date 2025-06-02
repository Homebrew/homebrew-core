class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "cd1ca53aeb77444647349e0eb89f3858c217c6fe79d9953b39f7cb2eeaba523e"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34628d4aae3a7c28fe96871f10c48db95fbe49f40ad2b9dccc0fbd8970b8054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cd0d44922483dfd35049bcccb24b0efee2b33d6cbae511cf4bbe84b5fa11d2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05afa94ec45ed016832aa7fcc0f5bdeaad404a937fe6340caa36a65304d8edd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2847bedb226c7d4e374cf5310d1d56593652518cab66d445cbf889ee5e533046"
    sha256 cellar: :any_skip_relocation, ventura:       "54b2236457ae57ec543aa9aee40ea0b97e50ae469fad6b1461119a992a712661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f524b3405654ead0ae0fa30c2670ebdd048ed07cc83da1e6a344c8333ae7c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ead749ee2a3e15417ee7866047ca14740fdf2203dbafb38ee057a08bbffe888"
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
