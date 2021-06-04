class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.24.4.tar.gz"
  sha256 "6544524f5ee2118609e8d47daa7851cd128542c5c7f904a1b4859fbdeaba73bd"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e296ac92b64e14e80233a03032a8853cfe79c73cfb10c0f1cfc6906482a4e3d0"
    sha256 cellar: :any_skip_relocation, big_sur:       "065814c6ff90b163648818c7344c8f32c6bd09ff27d0e20c17663998c9cdff2b"
    sha256 cellar: :any_skip_relocation, catalina:      "44390188e50a25830afab0b2fc197fc74228e2a899fa013ea845d1ea6ff39ff1"
    sha256 cellar: :any_skip_relocation, mojave:        "6d785b58ce91879ceaa9f03769262c1f897ff273730e2f3b8dc06a67a1658306"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build",
            "-ldflags", "-s -w -X main.pkgType=#{build_from}",
            *std_go_args,
            "-o", bin/"lean",
            "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please log in first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
