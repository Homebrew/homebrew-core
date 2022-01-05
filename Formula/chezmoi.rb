class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.9.5",
      revision: "af9290311e64e9f34b090c350be84070d1845863"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0fe12a4eaa4264e9d41906e0ea29ab1e00a46c965421718f820611939787b5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c881e41a649c173ba631a6b2620fd0e8c06e102e3e6770a012e7adb260b25f7"
    sha256 cellar: :any_skip_relocation, monterey:       "466cf22a86a59e7a42670c3954b3c3436c45afb9b0878adf737baad3f327a3b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb851569abceae69fe61422aa76f26b060c476316fdb3a74af0ec07e2b14735b"
    sha256 cellar: :any_skip_relocation, catalina:       "1ee2563bf6d081f851dc4d47f1ece9781217bed4acd850d4e4235c77c027dd98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7ba5ecb07ea61be7c1a7036801975f569eca5bf6a4d114f0a465e43e98e5e0"
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
