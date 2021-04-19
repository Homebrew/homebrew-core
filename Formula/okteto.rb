class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.8.tar.gz"
  sha256 "ed59dedde11d5134c96456707a0984c3f23a86a63b979e1fc70b9c6d0ad241cd"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "adf15fedf0a7754034e8f486a7dfd49eef4e316f0184b0417cef63eadead7664"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe1dee28d22b28bd91cd2fd249b0e2a3625cfca77561c87ef5976648c95a3246"
    sha256 cellar: :any_skip_relocation, catalina:      "242bcd95e78ade0ccd0842f61d59e7e63f4f030e1039f92f9f7dc1d2366ccd6a"
    sha256 cellar: :any_skip_relocation, mojave:        "e84998b5b0f3245d92b0f7a237459943c98826b6345bbfb349b2fc43275d53e3"
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
