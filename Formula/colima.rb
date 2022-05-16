class Colima < Formula
  desc "Container runtimes on MacOS with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.4.1",
      revision: "5d39343b2bdc827e554d78ae306ebc836bf1d02c"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73d6eea88bfc481e49649a21670d3ff14142aabfa1b2152f554410f388460637"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8fac60ae829103895a84300d8e56c69463f46f29a6dbf912060197cd67c01b1"
    sha256 cellar: :any_skip_relocation, monterey:       "d17f095141530ee948ff1ed0b41422305961db5eea74a4776c48c3bdd587aab1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6236d3190c2cf1dd602375370ee5727c559f41661131e25ff5532204293be5db"
    sha256 cellar: :any_skip_relocation, catalina:       "6df4747ef26d96335a171c9f629474121a6070edc464a56666074c321175a272"
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
