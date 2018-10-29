class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag => "v0.1.3723",
      :revision => "1dca9bca890201f12c6229d28aa9987a989a7eb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c9e40da0b79127997fdc2edca23c43887d2ac6914529dfb6402bd2b23d64f87" => :mojave
    sha256 "ee796b0218bb214313e6c81dca55a8cefbe44f704b52d539893f43a9bd52eb23" => :high_sierra
    sha256 "cc7efdac49546a0c27b3a2196a6096c896d254a0c5ab90f35ec16f6b9b450853" => :sierra
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
