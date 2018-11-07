class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag      => "v0.1.3923",
      :revision => "6fecf9d611e14f99bdf7fb668ddc87bab190ea25"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf3ed91535923cec6afb2def53656f384d95e046567c719442a71230e6cc4cff" => :mojave
    sha256 "1a9e74f74dae17d2bd9b008e3ab1d6d5fa20e21fdf733faf131a0f29fc399326" => :high_sierra
    sha256 "0924d11f832e28c5aed1f6c71e37ffd8aebab78d44d4eb01dc0f87e7feaaa5e8" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/CircleCI-Public/circleci-cli"
    dir.install buildpath.children

    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = %W[
        -s -w
        -X github.com/CircleCI-Public/circleci-cli/cmd.AutoUpdate=false
        -X github.com/CircleCI-Public/circleci-cli/cmd.PackageManager=homebrew
        -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
        -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{commit}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "),
             "-o", bin/"circleci"
      prefix.install_metafiles
    end
  end

  test do
    # assert basic script execution
    assert_match /#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip
    # assert script fails because 2.1 config is not supported for local builds
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci build -c #{testpath}/.circleci.yml 2>&1", 255)
    assert_match "Local builds do not support that version at this time", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.", shell_output("#{bin}/circleci update")
  end
end
