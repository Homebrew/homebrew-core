class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "9df4ce00cbb441837f480cf1dae2810ff453ff82e34f93ea3c5878748fe7edc8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0192b7d1ee3f99a50853ccd56a6d63ed5b89ea581758f1e1261aa4c41b7ae072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b911f1e7a5de2859dae89d8ca43747ed6799fcea79f0292b61c6965170366450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bbe5566e3a1594304235e9ab8760381a4db8837fb410f4e9a3e15c49210e95e"
    sha256 cellar: :any_skip_relocation, sonoma:        "83908b8b45ac465830fc490d42f37a75130cece9a3c3eeb4b8b857a2abd0ae05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70ad82f7d821b5310db05624c78048b19044b7f3e1b451922520e3781f11dc22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "987f6dda2aa764d466f311c92085b6825398b75d8e421ed99512e82e67ea3391"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end
