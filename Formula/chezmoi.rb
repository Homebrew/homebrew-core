class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v1.8.5",
      revision: "c5dbedcf0256d6da92f774eb57e8d1d198f6e6c5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "26707baf12cca4c9f8e339cb0d24e96bf47882c99eafbb79461babac6b728e32" => :catalina
    sha256 "63c264018eb024f79715e96559b6da3083e3f1027efa30b790e9b908f872e435" => :mojave
    sha256 "8c42a5555ba6f186dc43cbd4de2a3fed182bb6fdd6ff8bce23acfe60e4a1dd27" => :high_sierra
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
