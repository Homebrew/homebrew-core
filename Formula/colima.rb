class Colima < Formula
  desc "Container runtimes on MacOS with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.3.4",
      revision: "5a4a70481ca8d1e794677f22524e3c1b79a9b4ae"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f34f53e048779b309dfb2b963e9b19bb787c9cb5bf65c92b7118eedbdf2380"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82f323de9897457f28f5406dca841e6401611a481a15c028ca359b0e4cf9bcf8"
    sha256 cellar: :any_skip_relocation, monterey:       "b3dc2f698e2b4d1ea5b657ef85fa031368ebb2b4d664ebd4a8b1c542e85400b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc308d75e40b2fe827c109d561bf19c13e1929b52ec15d808278e221552f4da9"
    sha256 cellar: :any_skip_relocation, catalina:       "5f3b080c5877c6b2af3e546c0d548e95e64bd048f61e8f4a45c9a492d035c04c"
  end

  depends_on "go" => :build
  depends_on "lima"
  depends_on :macos

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

    (bash_completion/"colima").write Utils.safe_popen_read(bin/"colima", "completion", "bash")
    (zsh_completion/"_colima").write Utils.safe_popen_read(bin/"colima", "completion", "zsh")
    (fish_completion/"colima.fish").write Utils.safe_popen_read(bin/"colima", "completion", "fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
