class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.14.0.tar.gz"
  sha256 "bda3f6afba7eaf634bec41bf6d7147e02056367f84975d8e90c49ef3b230aa7a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a43098e6a61440fcf441d7ca295d2376267a4a15e316f9f046ce974b016119be"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3262c6248dbe829537f039b21451d668bc150ced4ca186c1994f812ea544df8"
    sha256 cellar: :any_skip_relocation, catalina:      "9524c0e80ba5c3102b60a0bf96a3c3372fdf1d8f02356148e857887eae65eee6"
    sha256 cellar: :any_skip_relocation, mojave:        "44eb84a19cc8a35f7129b5758c14dc6d21980b57763f6830463093ee870200a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc874df1a98f2aebc21b5f2d0c5c451d93dc61dbc54fe9afa685f986afdb2db"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
