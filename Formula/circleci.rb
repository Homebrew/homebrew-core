class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag => "v0.1.1430",
      :revision => "9788d7512e7e4018f3f98f471d874cab66475175"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd57d668341d8b7cf038c0deb84b62c7f33dad6b1bc062e3d2555e1f31a11808" => :high_sierra
    sha256 "2b5313b8046e4e2a57c42b91eb0ee774bedc973d5f48e0f4c40d6b3a806e5fa1" => :sierra
    sha256 "c7ddaab682323694fbf54de39ec56f47a5f9a7c420841f5b3a13e517c774c9ee" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "docker"

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
    # assert script fails for missing docker (docker not on homebrew CI servers)
    output = shell_output("#{bin}/circleci build 2>&1", 255)
    assert_match "failed to pull latest docker image", output
  end
end
