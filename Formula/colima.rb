class Colima < Formula
  desc "Container runtimes on MacOS with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.3.1",
      revision: "787ae5631ae8de072feef95a509c47fc93308b2e"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6650c79eab4a44b5830d5909da32a4ef541368172bc2aca50ab3fe1d10e0446"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c171d79793f089931b99f4ebd02da8bb0d887c5714b2249ac0998aa46eae2044"
    sha256 cellar: :any_skip_relocation, monterey:       "517e3c2810cb5106005ddbd5f1fa88128f4d3bb9270b1f0d612fdddad2b6ea4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1632692f6ff4b19b012d7a1917ad08e0125b50a041d4ab71572930be0c1606f3"
    sha256 cellar: :any_skip_relocation, catalina:       "200e8ffdb817cdef4cd7d3cb56c93a83fca3843efcfb22ceedd3bebd40e99caf"
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
