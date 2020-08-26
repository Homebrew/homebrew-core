class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.9399",
      revision: "908cfd585d7aba546229308d9d131a065ddf6a58"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a741dfbe35f35825abf211fddeea2714ac1e3787b5ab5f28c288c3909762296b" => :catalina
    sha256 "01ea99a71a269400d3df3da57ca4a27e92cd8d95a3d7b02e5a2a8ed050df0468" => :mojave
    sha256 "774fffae1d17df3f33d91d7911a3f6a48a7a2111749b961c590ff0bfe294f8d4" => :high_sierra
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
