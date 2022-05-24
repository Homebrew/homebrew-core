class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eed821a11febd18fa3ae73096c6730be8d494e874d52130178d64ddba0c27e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "166f45b935f1b966f41bd2fc70a4b9a3630526ddd6d938501baf8d14cf0befe3"
    sha256 cellar: :any_skip_relocation, monterey:       "eb0f075e0a2a10d623f616a1dda562b3f9fdbbeddada7440bc0fbdbdc21042c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d11f233ee38a3d7fbd08244425adbf00385b8fda4ef9f21a56bc27cf3854fe88"
    sha256 cellar: :any_skip_relocation, catalina:       "7a2c9b9bc3bf2c18e28650b16dd7f6b68ebb52186513d07a67de7b01ef16a255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7625665511379d4b7f8c1bf06f9bb1cdefb5a75eadf9c9fc496bc3250bf79665"
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
