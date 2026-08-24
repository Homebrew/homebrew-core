class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://junegunn.github.io/fzf/"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.74.3.tar.gz"
  sha256 "5b142217c3068647a7d8faa9c678cffada100b5f11a48609aa79c94ce04b28ef"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a00d85ae60381a4a945db1c6e0564a7d9236237242ac107f95f63269f891d2db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a00d85ae60381a4a945db1c6e0564a7d9236237242ac107f95f63269f891d2db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a00d85ae60381a4a945db1c6e0564a7d9236237242ac107f95f63269f891d2db"
    sha256 cellar: :any_skip_relocation, sonoma:        "72719ff9522c1fce3245cfe9fcb04f6dd07c82788b78cb4f2bfcd7a05264de0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd6d27a30bfec18151611fcdc4699a8bf23698d3414c680ac818a9e5d80d0150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da8748919980918205f6dd549a946bb95b10253c8f3c8f84c2dec39bf7e184d"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -X main.version=#{version}
      -X main.revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
    bin.install "bin/fzf-preview.sh"

    # Please don't install these into standard locations (e.g. `zsh_completion`, etc.)
    # See: https://github.com/Homebrew/homebrew-core/pull/137432
    #      https://github.com/Homebrew/legacy-homebrew/pull/27348
    #      https://github.com/Homebrew/homebrew-core/pull/70543
    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
  end

  def caveats
    <<~EOS
      To set up shell integration, see:
        https://github.com/junegunn/fzf#setting-up-shell-integration
      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version")

    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end
