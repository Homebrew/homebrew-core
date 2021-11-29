class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.9.0",
      revision: "f9ba484442ad5ec2cc1c14fffa5fab05779546c7"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5772d8e14edb2a1b8fe8454ece665f0f1b770b72bff3b0fed56aa8d0acbaa4c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5cb72db1d716f4d774e18d8d514c28531d420d9a5581388d248394dfcadaecd"
    sha256 cellar: :any_skip_relocation, monterey:       "cadf188775721096872311e411d8286f93149bc08649e07be0b2072fed27e6cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d32859836f2d237063adda6a9920548d25789efb3a9adec4b48c6ae5ca3ff3e"
    sha256 cellar: :any_skip_relocation, catalina:       "0f665132ea79a712fbcce822afa5e7be73e94fab135b12d3deee2200f1a31ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30cc88c785e6c8a8f01b1af46ec32477dd789b4e727b7f690590ebea3c1bdd88"
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
