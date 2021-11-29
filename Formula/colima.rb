class Colima < Formula
  desc "Container runtimes on MacOS with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.2.2",
      revision: "b2c7697bee2d73e995f156fe8e9870eb246c07e6"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9747ca65ca6be26b4263e1bce95c1a940701c536fd0f87b58832691f74881896"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81d0c6180696757c3a29e4688128a31ef06b3f3ff6a45a7098e67ca5f2fa0e99"
    sha256 cellar: :any_skip_relocation, monterey:       "79d53bbe6644ce662a7134c2846cc431731eb37c2cc0ac6fab7943f5fbca6d29"
    sha256 cellar: :any_skip_relocation, big_sur:        "f03962f3ac2eea17cb4a7c716a86c703a5f17da0ae76517ab8e3bac2002350bf"
    sha256 cellar: :any_skip_relocation, catalina:       "6ed11d66cfc5537d24f1861bf764d88bfab103fd86b4278bc45c0f01e4ad27a0"
    sha256 cellar: :any_skip_relocation, mojave:         "96faa5778cd2aaf10f5df4ec89c824f19573955add9cd3da68265d12688297fb"
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
