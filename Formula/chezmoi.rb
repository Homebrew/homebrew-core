class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      :tag      => "v1.8.3",
      :revision => "6d2be34cda3461ddf1211f98fdb10c00a4e18d67"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb13d0b336530dc43fb1a9d4049e9ba1bb52c9f4a86b3904b133772c65929642" => :catalina
    sha256 "d38518b88a41af06b375d6fa2ab7c028c3b22d2064000d87aa3022b98d3b6f22" => :mojave
    sha256 "d90ae59b97acb8e4d98564277dc7d1f12c5028c18a2cd7947a03d1dcdea0bbef" => :high_sierra
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
