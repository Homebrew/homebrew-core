class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.15.3",
      revision: "b525c5040f115d2718cd24c4b2385a13ff013ca7"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98265cd8ec4229440fa16acd2fb2f14cde968befdc0748417126fe82b7ba8557"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b489843704e93367537f5b7651582493aa570deb406a2beaaac22f8914a7843"
    sha256 cellar: :any_skip_relocation, monterey:       "d55bb813a7ae2a9f3e3de17aa46e2ad17b985b23cf2b54204164beea4e7b0d72"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c3bdda7bd3d85b16235cb07c1300e744572ef782cb81d7259080613592c1525"
    sha256 cellar: :any_skip_relocation, catalina:       "d5b5df995e6200d68fd16fd256260620dd8332e9adf12b0cdbd00461f0312be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37dd30e8d27e317d4a927398577760c541bd837e2885d6f15bae282e96ecb702"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
