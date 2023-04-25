class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.33.3",
      revision: "fe6010e8b2518ddabfcd5f58236763b4f2e90ff8"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d37f129464e20eaade618e5e35b1ae5b6ba9f0a20af708e1d33afbd7728e46f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7062f98d5c8dea76683b519597359c387ecb9ba5ad28ae4623aeb6c877a56f18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b12e700a6cd6ca233a4a112daad1f671abd485dfb2db35ecdee686cceef7fe2"
    sha256 cellar: :any_skip_relocation, ventura:        "dd1ab2c01cc21f5e3c4578d3d24e1187d53d82d62946ba33592780db4d958727"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec0d5948f1785939d0c2f755f8325b4aef6b8c860493026a6099586fc54b1e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ea6ab850815f9f160b378b04148b6bcbef82f547acb6c6875566c2f8ef1c080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6013f5c0fee3d4eab40984b8938df87a49baf5c86b003ccb996de5c9d4442de6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
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
