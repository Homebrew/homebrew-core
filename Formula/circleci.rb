class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23312",
      revision: "b7a08c29d361bca7719dd47f1cc3d33934d00fac"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "720331095be9fc122601a017a0ad91d59c41e061b43340f99f034b4343a6104a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "022e30f0bcc4173bfd42443aa7cb8d29588120d0754772d02d99931a17239fe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f7ec2e2d346812d6cacd026e584b4b3d5c34c99d36db91384e59d69ec66db39"
    sha256 cellar: :any_skip_relocation, ventura:        "0a837c80b4554eb66466f2dd7f06425d04f9b92d124d37438bea7f3676e22827"
    sha256 cellar: :any_skip_relocation, monterey:       "2b3347462628e54e9c3116c70e67dc8b373fbf4dc644de1dfb9f87ef8c606d0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d930a4c206b556c49d24367fed61bb58d50b65afe368e9823fd77f1975879284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c02ad73e2d107933a1134cebc6a70ba8ba62a007e80eb693657a6e25c982d0a5"
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
