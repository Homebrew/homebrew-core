class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.69.3/chezmoi-2.69.3.tar.gz"
  sha256 "3066456892be569d41a2186200b03e59d85a44424cb99d5b9f70aeb2337b6ea1"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bfa268e43a9e9c3e8cb9995fc954260d39b131b610c3f7e3c16fd7f7e98f200"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0efda08dd0998188494b0b8612ceaee3f5d291334cc188824126df7ea25e7ed3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10cc7be7802861e57b611fbe4360dfae9394ed10b2087f8079e76cec660bc35f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a398926f89b29d290f9931f7b8a87e1a788fb988812a9b0417d51ee432683eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "512dc5facc1caa0aab5905a54b2a962e0c2c1f992c910511fb28c48fb4ecd463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81fb46aef340c402c27a9b1bf93eb18c6f52369306463f354d645cc1581356c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(/commit [0-9a-f]{40}/, shell_output("#{bin}/chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end
