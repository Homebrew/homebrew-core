class GitlabCiLinter < Formula
  desc "Command-line tool to lint GitLab CI YAML files"
  homepage "https://gitlab.com/orobardet/gitlab-ci-linter"
  url "https://gitlab.com/orobardet/gitlab-ci-linter/-/archive/v2.4.0/gitlab-ci-linter-v2.4.0.tar.bz2"
  sha256 "caacfabcb3e5d01b821c685d443b709c464b999a60f72bd67ead4a2d991547d7"
  license "MIT"
  head "https://gitlab.com/orobardet/gitlab-ci-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc37c298c817d2e5f157425e6a0085371d236752da86c8445bc0f95496564683"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc37c298c817d2e5f157425e6a0085371d236752da86c8445bc0f95496564683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc37c298c817d2e5f157425e6a0085371d236752da86c8445bc0f95496564683"
    sha256 cellar: :any_skip_relocation, sonoma:        "b39c7882d3c5a83b96668ffb1fe693e956f3787e462182b9501c13d4f74f718a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82e74dc43a4a609bbceb7ffe5898decf6c03a139fe7be6fc516be670be520eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b9292be7478c52c6b9852bc2a89ca00f3439ed12557f8b0dcb5ec65af128edc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitlab.com/orobardet/gitlab-ci-linter/config.VERSION=#{version}
      -X gitlab.com/orobardet/gitlab-ci-linter/config.REVISION=#{tap.user}
      -X gitlab.com/orobardet/gitlab-ci-linter/config.BUILDTIME=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-ci-linter --version")

    (testpath/".gitlab-ci.yml").write <<~YAML
      stages:
        - test

      lint:
        stage: test
        script:
          - echo "This is a test job"
    YAML

    output = shell_output("#{bin}/gitlab-ci-linter check 2>&1", 5)
    assert_match "error linting using Gitlab API", output
  end
end
