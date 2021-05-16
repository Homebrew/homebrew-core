class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.12.tar.gz"
  sha256 "32a88432fc028ce389e06d97f89d8ddcd79d94f7e762c990f3ec7ffd0b74bf3f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8f0730d8acbc92c4d1e1d44ed199f1b7740cbd294fbe5ebd0369ef938798e4ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "580b3fe35b0668f1582e5cd50e417ebc80608506a58a43643747b4d361191dbe"
    sha256 cellar: :any_skip_relocation, catalina:      "cc14671d7fb628e6d365bb0d5af815964878b24f60d7e09cf3895ee6374aec07"
    sha256 cellar: :any_skip_relocation, mojave:        "0c465a1fdb415e23a7958ab8522c1771acfc74f210c8019aa816171ff463a040"
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
