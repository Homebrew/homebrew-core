class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.49.0.tar.gz"
  sha256 "10353cdc817d020b4ac2175aa0e45ac72cba2d11e16829e630ace7f5fe600ba3"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53b8325d75689e4b6fa31c753178c1c8cb8d70cb22f05161ab11678148d6dcd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6484199e17908247dd9cb1cb07c40f5827294335d8472eb846f8aa69a329fab5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d26f5e2a0bd175468047c6f26976b9bcb6cc66cfe06b9a3e540a2b4881c3fef6"
    sha256 cellar: :any_skip_relocation, sonoma:         "110413a9bd32470bfffcfb3a73e864a898f6f73c9da706cfc82e9673bdd0be07"
    sha256 cellar: :any_skip_relocation, ventura:        "f49b6f203a30edd167074488d725956df25698b870533da50379eeb0e8b675ed"
    sha256 cellar: :any_skip_relocation, monterey:       "cc3a2180f24f18b63540ffa7012d795b993cf974593c4e4f43d73f2793c1430d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f4f3a48856e726d8adb6f9bdca25588d82b5ef922dbd4f2ebcd2986798a79c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

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
