class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v1.8.7",
      revision: "3b285d96b45f4f832775b771d39c83e6442d3b4d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b3efdba6cf70301eef4fb4e27504a0dee3f7f9238c1302d487db9def578820b" => :catalina
    sha256 "0c710e1df5eb10c66d50b3e38876a3b502c3fddc3ca3f48d599e925bf93f108b" => :mojave
    sha256 "081bc4f957503b67e14c5dc5b0ae327cd014260af68c7d51022d63e026eb94df" => :high_sierra
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
