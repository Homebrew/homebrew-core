class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.27.0",
      revision: "92993ed1f980340876a1b44e39ba382c41309053"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d969a76ae9291b0dd1ef87d5dfa81d649a09d111eb35f1c3037e73f7e6cba3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7bad78ed2f65d364a0c132a971367401bf9883efa1a8e7ebe6373f3e22e5086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1a758e23c3a6a643d6f99f7ac69883aaf7f426e39fb17e54882a41b06520e89"
    sha256 cellar: :any_skip_relocation, monterey:       "cddc7b2509f9d012a4e74755d13ec13bfaa25cb9149cc5556b7bdd01ee8c132f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c9be31c3fb8f1ced5f1dade1c882cad14172aa69e06b101a6ecb963422926ae"
    sha256 cellar: :any_skip_relocation, catalina:       "90063347c45b456b731002375a2ae1ed69228f8c1c54a558585ce0ef2af832fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c5f769e11174aa2e6b5297a0d501eb85c3ef3733831bbd48980c9d23daffbd"
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
