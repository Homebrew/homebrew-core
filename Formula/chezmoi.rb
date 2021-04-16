class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.10",
      revision: "3782e9330712b143a3c6383ea171091784fa2de3"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8549d89f47280021a9b9b9682105f50ca9d02356e80a3d4de0c54de219217413"
    sha256 cellar: :any_skip_relocation, big_sur:       "e4a9c9b52ad283bf52938fb4c40a1d9e2780fb5bfcbe7122fc4f70a98a8ba460"
    sha256 cellar: :any_skip_relocation, catalina:      "23eba7f2658c93a5ef8689120cbe24a76423854b7563dcf0eaa6520262df5edb"
    sha256 cellar: :any_skip_relocation, mojave:        "1545fe6753a8ab23361817805bb1434d4f151bba2354bf6457ca1d1bf62660af"
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
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
