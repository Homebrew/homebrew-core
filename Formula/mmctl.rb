class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.8.0",
      revision: "f61f2a08684ece90f23b02bfecea0b772f1653e9"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "556c2aa64eb2784bf64c7093d69524585f26ee6053385e3b7a832878b09d39f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e42fc865627d50540770adb4b4d1100bb67737e6e1666425b434b26450d10ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05a1dc4c3fbeb28645602e6c6a9b325c137d4df3f214d0914ada520a34771a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "834774e9e51120f3f76ac47a00932a1b74e24b9da4542d54a7a881b7225c0c36"
    sha256 cellar: :any_skip_relocation, monterey:       "13b58d7ef1c35d2765b85f227f1e854caa6e18f18e4f1b1f79a867cdce68acbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2565350dcbf718397d4e1f131cf619a57a7d01718686024f498297e0213a404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad243ee2bbeb9059fb8b7aeb46b4cee67b924d53a6749d6068bdb509a7222851"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
