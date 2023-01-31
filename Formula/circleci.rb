class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23272",
      revision: "b56f979bba9679e11bbefab4218c25272b66c913"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81b311cf59edf902d9f241f29429c30494a239cf69809dab14bfa45e600ce914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82f613c89c25d5024e5ed0df97a9b27a4fe9d389aa1f74cfcd6f162e59729079"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45f287562849e20c3fa1c9715c69f11a1de23374c661a3667a86dec4e293398a"
    sha256 cellar: :any_skip_relocation, ventura:        "2441d38ab0a8459d00448040c6fee9dd3cdfefcbc92917e26380ef0056873597"
    sha256 cellar: :any_skip_relocation, monterey:       "f04f3c91aaf922ae8023c03b020447ccabe4d330111622fd31d54c7c35182cc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9b0816ad3a3143119838dfbda6c01303c63420d3257942741d4c40cb1f57000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8633054be962d111e4a1a59b330a5e9b32b376dd4eecd19305bce0ef90a509d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
