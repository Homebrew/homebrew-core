class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.7.3",
      revision: "32a15ac909ee8108d0eaeebcdbbac2305e32a9ba"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "185cbadfe3e25e736c9cd185da8956970ecc6bd060240b690fe5af7484a89c25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12ee8ae97a68f40403efe7c38c28665f18a623d237b2da6b9362cae5ae7e8684"
    sha256 cellar: :any_skip_relocation, monterey:       "9d6b9cb61217f870a99efe200b6d0bdd89662ec94f472616af786a7aeedbd96e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cee77adb104124e354be4118b12c2f2f6d14dda75ef9b9766c36059e6a5f9dee"
    sha256 cellar: :any_skip_relocation, catalina:       "ca1e38a39f3cb20e3ae1f739ef0974b5a114cc5a51c7a827d976d37351596906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01113b99fccaf20401d2318b0f81148aeb6835590f85a3c6ba9dcbb56de6072c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ].join(" ")
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
