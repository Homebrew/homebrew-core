class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v1.8.10",
      revision: "11ed57d9a7e86434744f336b595ed0fd19aff6f5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b735a696e3d2d9e4acbd3468a525b32814e127df190bc1cc36c8cfacad827214" => :big_sur
    sha256 "109f8906b4d1367159b2ce9dd29493aa348d3f49450bfea70a980392f38285b0" => :catalina
    sha256 "7a845f5d3b1b96b7cd0f94829f3d012f073cbec5666b57d8a8950362478a1674" => :mojave
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{commit}
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
