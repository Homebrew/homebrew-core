class Colima < Formula
  desc "Container runtimes on MacOS with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.4.2",
      revision: "f112f336d05926d62eb6134ee3d00f206560493b"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26fd60fd101fa99b14fe988ad05262b38a2920d2209b465f6b3867b28db553c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56362cd0fc82834dfc09c8062e82d0fce4424d0e0d8313e04da77b12ec502094"
    sha256 cellar: :any_skip_relocation, monterey:       "121bb7a082a774ea466cb832f61b4a92bcd153457aace263ec244b2155b551cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6ffc34c919fe6fcf47c5ddc83ed0aac6ee6b62308e119c3bdbac2fb5ccfb691"
    sha256 cellar: :any_skip_relocation, catalina:       "3d6f8e87a4481bf9f1f6b0511113612cc8964e2a493c299d501e1e737f1b65d8"
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
