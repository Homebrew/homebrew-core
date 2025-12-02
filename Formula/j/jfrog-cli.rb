class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.85.0.tar.gz"
  sha256 "b374ccfa30ca20292b98de06f006bbbd9bf0ad7b9c6e678db3374c2245eb0159"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07234a34d5b98891b9889a5edca8b8b37ec2c456c37ca994e8b00af03bda8b93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07234a34d5b98891b9889a5edca8b8b37ec2c456c37ca994e8b00af03bda8b93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07234a34d5b98891b9889a5edca8b8b37ec2c456c37ca994e8b00af03bda8b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "90826b582214b7642611701b87719058541be7bd36c81c63bebc49722194d0b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6b6aa1c47be7af4007afd6dc720855059f81c5405340756152475749b221f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f79027ac16cc3035695a9e9a0fae08462132f49103fc18497e5866057333f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
