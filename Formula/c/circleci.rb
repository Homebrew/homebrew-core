class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49592",
      revision: "5f1ba58d804609ab81292ad3ee58edf25bac90fa"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "930274197c51357a44f17f26b69670e77e0f378cc02cb62788235d714d802def"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3ec85a084cca75b64f8ef9a2133dfcd5a5134c866440d872f2a376384f88db6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44b513f8e044cbccb59eaf353aa5e1d94f10b5594ddaf748015a40aa205327c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68c35163965366a4e0edec16f96e2a9309edbbe3686fe4a4babdafa79ba5087c"
    sha256 cellar: :any,                 x86_64_linux:  "93b70de50c74e19e9d19d3329f32bc3b35ee2711283599509076fe1478be6ae8"
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
