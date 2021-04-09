class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.6.tar.gz"
  sha256 "2e6aa816bffcc224b82541d7a5e279abfa4edff0c61e3fbc8403206e2d56a8f2"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11a9940bfed06c9c809902cfa5b3d711713997aa928071d79ea8ed9f117a2726"
    sha256 cellar: :any_skip_relocation, big_sur:       "86f9733cd1e3a90a85c9f965e0519fe26d20ee2de3710f880f1b0f38e392f557"
    sha256 cellar: :any_skip_relocation, catalina:      "d406666816b380e0fd395b21d4343ff0568eef2e555dee0be58344d539e1591d"
    sha256 cellar: :any_skip_relocation, mojave:        "21d0dbe334f139e1727875b628795f59eaf406e2f23aadc5f2e17d2905ab8dba"
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
