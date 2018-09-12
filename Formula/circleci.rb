class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag => "v0.1.2061",
      :revision => "3eae4e7eaa2f09f44a8bf812a292de729d1b681d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff5e35c76d0a39229cd8200e667f7cb9229836445fd78a3ff884511c374631b6" => :mojave
    sha256 "aebfc7302bd2598c26e722e543585346f3473125a212596b8e1b7c8845f8221a" => :high_sierra
    sha256 "61a586a8b1c32c592b33a580cfcbbdf3e7957183f88d2a3475be4f400fa9dfb0" => :sierra
    sha256 "8256dbe0550293b6be5ffffda2baf2ffbf1f0d6909132605694023a377829ca6" => :el_capitan
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
  end
end
