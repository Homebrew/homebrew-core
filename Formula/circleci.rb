class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag      => "v0.1.8599",
      :revision => "d6e83e78520892de88019005ebf071f671283113"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a26df6b9686727e98418ffc3eb28c83689e202d9360d56eaebe358586be074e" => :catalina
    sha256 "df2b01078f81928ebff0a17b9580a0105ab1ac5606513db5661fd56539c584af" => :mojave
    sha256 "8aba332a6953247117def80ddd864c7c04d72876cf8389ac8f5436604beb44a4" => :high_sierra
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
