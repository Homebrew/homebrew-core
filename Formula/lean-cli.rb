class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.24.4.tar.gz"
  sha256 "6544524f5ee2118609e8d47daa7851cd128542c5c7f904a1b4859fbdeaba73bd"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4501a59d653062563f705682ab19a8621aac54efa3114983255ed3b4479def3e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c2fdb9c96635a3d8d45a46cd5d43290866d1c8ed5b0ca4c6c958c0598c7a9f0a"
    sha256 cellar: :any_skip_relocation, catalina:      "3bbf191c95b9e07d750970a1ee0787f5acd680f204029d40b67bb3a40e3698b9"
    sha256 cellar: :any_skip_relocation, mojave:        "08eebf1914750b5eb027aa3f4088459aa4ce8dad4879f7ba12fcb20aacf9d612"
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
