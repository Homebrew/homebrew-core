class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.31.0",
      revision: "4d2bc846212e27fae1e5bbd45d70e00908da603b"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c983369646e10789d3671bc9ec3452c22933833f58b183863b6c821faae864d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7db35913bb928fc3fa9a7c1a66494127d317408fb94316147f25b19809dc1166"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8268b27f17892d5bcdb0e9093a3ad3b325d432fc46c552df4f6b85530f263a20"
    sha256 cellar: :any_skip_relocation, ventura:        "fbf9b46e919c474d1b5ae03d8f83a4ce8fefde9e215f121085fc9431a852371a"
    sha256 cellar: :any_skip_relocation, monterey:       "25597ea2eb74057e8c7103dd19905bce4c519f5e75d5410eb65ad6b1dafbd39f"
    sha256 cellar: :any_skip_relocation, big_sur:        "de1a98e932d88349346473401d6612c281634588dab42469c903965db28e1703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea428ce39e3a5e15e93a9c845a6968ec287350677519a9e72c2eee5525a6755e"
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
