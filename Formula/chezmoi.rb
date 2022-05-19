class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.16.0",
      revision: "1a63dc28562307ca34ed1be92346e088cf7c71aa"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70420e13d9fd8bc935ca7081e5fe25e8b9030901af642c812fd01330ad8256bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "243d872ec65934b2b508a57b48202b56f06aa6de53eaeaaf744e227a0548ae2e"
    sha256 cellar: :any_skip_relocation, monterey:       "07d9395368ae6b1822dce8e72cba7a69ebee8e2ba99e63294de34db7c89a2b13"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5caf9bab7935e74ccf1a91678b0bdb113cf23763bb07481226870b3b000b69e"
    sha256 cellar: :any_skip_relocation, catalina:       "380fc8b4453e400bb90403fc664dce377518b53cdac007d2c96bb941dab0b278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5fed887338e708abd6a01226151fa99a58cd49e0abef2bb2cbf3623cccf8282"
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
