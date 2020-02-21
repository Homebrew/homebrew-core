class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag      => "v0.1.6220",
      :revision => "664c4ea4b05c9a6a1b89671a34cb26d58681bb85"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c70e1810214aac26798cfc5ac8734fbecae1baee3af9af8b5f45dedca66d30c" => :catalina
    sha256 "48adff67b7d69ed1a6656a754e754e8cae67ce4ec7929a805c405bbce89eabc9" => :mojave
    sha256 "b82e42bd9c5026de007fbb5c684e8fd2875db82c25a935b9e22ff5563d94217f" => :high_sierra
    sha256 "37088c6cc436902542b008a3f78aad369f7a199f0d24cb2b3573d0e95a795256" => :sierra
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
        -X github.com/CircleCI-Public/circleci-cli/cmd.PackageManager=homebrew
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
    # assert script fails because 2.1 config is not supported for local builds
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci build -c #{testpath}/.circleci.yml 2>&1", 255)
    assert_match "Local builds do not support that version at this time", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.", shell_output("#{bin}/circleci update")
  end
end
