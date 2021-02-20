class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v1.8.11",
      revision: "2e5a76c23de034344f7a9fa89cd3088cd9b52ac7"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da785c92f04a6ba090a3709cbb92316afc5d5e5d7fd377bece70719b6d368b09"
    sha256 cellar: :any_skip_relocation, big_sur:       "9077a166a9b2b076840153f8a390489b44e213c62bec1f9f8961fa52ad558bfa"
    sha256 cellar: :any_skip_relocation, catalina:      "ef947be4d77e99f13f24d04a39f57b7145e0669e4151e0592056ce5250ab209c"
    sha256 cellar: :any_skip_relocation, mojave:        "27a39abe15552641b151583fc6e46241f366750a68527d37a4e38a85d2b24e10"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{Time.now.utc.rfc3339}
      -X main.builtBy=homebrew
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version #{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
