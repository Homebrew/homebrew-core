class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.1.tar.gz"
  sha256 "0a6063e7f7be26185c4550b8d502f8a4d5e611a93ed30b588e727d9b6b7bac78"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "925e016b0da4ebd3723ef3afdc8dd0c801bf38caf19284bc71a5fdd661156cf4"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea15b209c4b8820b9be22f7215ece4efb6de57563d42bbcbf2754080596ba2be"
    sha256 cellar: :any_skip_relocation, catalina:      "6135bdbbb6fa94a8c1c2878e6ca7dda454ead162788aa7f47cd3599096ea679e"
    sha256 cellar: :any_skip_relocation, mojave:        "76473ae02eaeed13b84a18ae37d3953ba06ef21d8267b09cc47ba5fca2513788"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
