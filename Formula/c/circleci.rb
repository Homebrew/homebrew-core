class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50365",
      revision: "c4ab549f7dc992db89ace59eb3d5bfcf823ca107"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9248af02ef25fb18878b03035bacd7f174857c4ac476db9e4723dffd3e6963ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41cec2eada46f03f890533a70b4a42e0d8cbaa63d6c67a87b5a132b7365e025e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "564ac696dbdf8b9b4ba3f5be9a2983713849c3267e33fcd531c669b5c88050a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2a0a52898df5f887f52dbf91388fdef003850d94b930c990e77f77a69036431"
    sha256 cellar: :any,                 x86_64_linux:      "9b0c36497a03240e0c74ccdbea994e5a55599dbb897fe4ec00b41a1fdef1dc4c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
