class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15900",
      revision: "a651f78487d42f6aa5bada7c8991e65be62ed5c3"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5215cf73a67d769cb38d5f05186ee9f5a7fcadfed7b3ed316a3009861447367d"
    sha256 cellar: :any_skip_relocation, big_sur:       "28df03d6840370915a60fa9e7fb0be1cd492a360bc52cde128eb3a535d666037"
    sha256 cellar: :any_skip_relocation, catalina:      "c0779610ede67752de1a57cd8a0e3deb3d895f53bebd18a2aa2c66bede5b1725"
    sha256 cellar: :any_skip_relocation, mojave:        "12d6b1c13ba60cacfeb0253714c68b19216f4b575beb6f3ae138f90076ae195b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42e330f228bc5dc795c1290f4e8436a374d18a8bf92efe9ec1f1d8d985219b82"
  end

  depends_on "go" => :build
  depends_on "packr" => :build

  def install
    system "packr2", "--ignore-imports", "-v"

    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))

    output = Utils.safe_popen_read("#{bin}/circleci", "--skip-update-check", "completion", "bash")
    (bash_completion/"circleck").write output

    output = Utils.safe_popen_read("#{bin}/circleci", "--skip-update-check", "completion", "zsh")
    (zsh_completion/"_circleci").write output
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
