class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.37.0",
      revision: "552d2556aa4b53ecd2677f9ef811376c42fc6c8e"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "245e97074135fca7afecf36f028e5fe22e459d375bda0125b856762c6bb3f2a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8e93718403addc65adf1ee5543d4a87e540d763737c97deca84b09b50132e78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d21336d845c319e32c32adb7c23584c096bdaceac4b2e5bac4e8d761c7a3a7d9"
    sha256 cellar: :any_skip_relocation, ventura:        "5a70d80206f1f18072e388a0499fc47614f054d120c4e74ab2f5e7e1b0df1bed"
    sha256 cellar: :any_skip_relocation, monterey:       "e72b5129b9a6b880fff79b8c6ca3c6e4af273171c5022db52c8bfb7d1592a5b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "55c6beffbd2d1003efda6ebd82b8be651f396cef09ebca8ea118afe5e5677979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f3c3e7a5106963eb23620f3cb558c87effa1bacf067e6b683f06737042f4e3"
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
