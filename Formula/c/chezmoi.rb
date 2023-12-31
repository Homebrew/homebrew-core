class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.42.3",
      revision: "43a4f5790ef1b709de881d36afb0a61745efa34f"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31a9f2bc62adaa80c3f3896b43507c4a2b1d75a62d89063791e539c7bfcdce21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eb6ef170a03b757c0b33f8426ffb066569b06fee208377c0d8e0fd057088289"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee6728d9ebae4ff2cf34c315753f94fe9b69fe092fb8c2a17b76856802cc6887"
    sha256 cellar: :any_skip_relocation, sonoma:         "350a89b11c450b09364b0f3bada534e9395804de50ba4157c4bc2eb3c1241007"
    sha256 cellar: :any_skip_relocation, ventura:        "fef2fd770d9a66cf3a4a4c35838388e4e6323710c9e921e69ea4e43c9625ad16"
    sha256 cellar: :any_skip_relocation, monterey:       "28d9631e31a98947976fbf23efc91ce2a6d379bbf0e5f2e0937fe2c1e7b7e494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1b5df24ac34c8d9995956ccf63e6ee5938aa1e5ca7e250fbd281bc049896bb0"
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
