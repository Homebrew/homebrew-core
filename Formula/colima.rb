class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.4.4",
      revision: "8bb1101a861a8b6d2ef6e16aca97a835f65c4f8f"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a65b9c18ad00dec27a393cdbdc9d346111d08ca33b9f7078ff0b1400eb3f6fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcd1ff2a3a95346f80dd973fdd6ff3b6ab77f03f171a09e08de2e56aa0dc45e8"
    sha256 cellar: :any_skip_relocation, monterey:       "6a6f8550e054e703d3a0d041c34f6473ed5cacbf19ed14b971c3d0538da673d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "19e4190c099ba7e7ecfc98d179590b11134df167c21a3a4289b218a01864407e"
    sha256 cellar: :any_skip_relocation, catalina:       "7573e704d6e39be040e0316686c77ced42fc12f295c95b2d5b98e97caa3cb34a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0e73b86200360c76d2e2e010236dc8ccf3aa5a01b3a72fb32cf6b6e56fa0d1d"
  end

  depends_on "go" => :build
  depends_on "lima"

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
