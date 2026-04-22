class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "d3712632060e1c14af81797bcfea42c9809fcd4a7f161f72655c25c39a2de803"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ce6c8ef8f40ae717271d264f48ee67973f48cc596141e2abbb97d568c2b9c59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ce6c8ef8f40ae717271d264f48ee67973f48cc596141e2abbb97d568c2b9c59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ce6c8ef8f40ae717271d264f48ee67973f48cc596141e2abbb97d568c2b9c59"
    sha256 cellar: :any_skip_relocation, sonoma:        "f17ffba1cba92ae22b568a356a428563bfcfc56da60294507e24c5732759aeda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98f8b8b50162c999b8808614ad1080b272b227dd8e9a0e2cc71e7f7ab6b02b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73eab8c3106b385a6cdab9ad81c988f4b0a77e0ef7f81f65df94aec148bcea02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
