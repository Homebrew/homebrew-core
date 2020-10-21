class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.11146",
      revision: "275febaff705bc4e095a594c221bd00ef553398d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ff9af3c6f4514d0da9de129195fb678fa6710228036b0ae758780f8df12c4a1" => :catalina
    sha256 "543f39092b5ee128a15037bd90baf9fd8a13f60e610d66e35d7f8222066ad352" => :mojave
    sha256 "155d37684a0b5577f17213987257dd56cf61cbb1c1194f15f884a8f0b1ff3140" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/CircleCI-Public/circleci-cli"
    dir.install buildpath.children

    cd dir do
      commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
      ldflags = %W[
        -s -w
        -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
        -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
        -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{commit}
      ]
      system "make", "pack"
      system "go", "build", "-ldflags", ldflags.join(" "),
             "-o", bin/"circleci"
      prefix.install_metafiles
    end
  end

  test do
    # assert basic script execution
    assert_match /#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
