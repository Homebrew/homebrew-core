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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fd84b532d548a8d7e74c89d756c7cc44a06419c6d19203b7aaadbe987f927ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e21d3295269005de7f1a585778ea328bdb554a2999d06128ba886678454f281"
    sha256 cellar: :any_skip_relocation, monterey:       "e2742bae8a63f67a168b366d3b455039092925f1d3dfa4daecbd8f1f5f350a2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c5a080e2be4966edad64ef619ae75b873d632da5100ae52662d62ecbc4bbc51"
    sha256 cellar: :any_skip_relocation, catalina:       "c0a115989a3783cd23baa7d1e2a7cf67fc2da657f9f1da2a9a86218921e8336a"
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
