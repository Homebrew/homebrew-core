class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.27.3",
      revision: "feab4e788831e803d84a544739dfb8188245deae"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a32504a5e8f37c5675a685e713157f039e3aa0d91cb5cc86f7525a96b9d14055"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12b1677f2073e9b861f7220a96a1e9675d52173556e19bbf002d131384e8d84e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d04cb4ce3ffe3d751f141589b81d256d372dd940150c768e09d1f6c6ad67134"
    sha256 cellar: :any_skip_relocation, ventura:        "25a74f8c947e9026bc4a04f9ce0bfc17df4306c4daf72d725518e11236864174"
    sha256 cellar: :any_skip_relocation, monterey:       "5a084a81e459284798c25b5e5e3aa059a2295b75ce9d47069f0adcb0c359f30c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd774647265240580705a6ee187d04d2e4647f8a78fb7ccc0918bc9c94bbb2d1"
    sha256 cellar: :any_skip_relocation, catalina:       "1ed9c59f52c013d769d4fc80e119bac7bc1ff8e3c4cdf27f767544ab86f5346b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38d61c24afffa1dbe6d73d4b5ffb697f62c5c627ed92b89a0ceb81a1f61dae19"
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
