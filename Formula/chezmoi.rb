class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      :tag      => "v1.8.2",
      :revision => "323cba56195179ade6b061fa2d6af37d16cd193e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d710e4191da60fe000518c9e234d9ab3b8893a052418fc897cc3d846c3b06114" => :catalina
    sha256 "aedbf0d3a525a7429e32a8e72bdf55b7eae2fde1a2e9dc8c5b88bd87fb0f333f" => :mojave
    sha256 "528643626bee5953ca37e0530be8fdf379b6457efd56bd44fa12d3931ef4863d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
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
