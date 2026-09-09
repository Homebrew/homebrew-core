class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://junegunn.github.io/fzf/"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.74.3.tar.gz"
  sha256 "5b142217c3068647a7d8faa9c678cffada100b5f11a48609aa79c94ce04b28ef"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ad5eca71970a9a7fdd5e6003d68f5dc2e2ef10e22215fb22e60ee1e14ec5877"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ad5eca71970a9a7fdd5e6003d68f5dc2e2ef10e22215fb22e60ee1e14ec5877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ad5eca71970a9a7fdd5e6003d68f5dc2e2ef10e22215fb22e60ee1e14ec5877"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a9d2260cdbe7895a49f6d7abe9d0833e0fb3867c3d439b79adf91d463fdce32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a691456ecd9919d51d781ea93d7635106e30419a12efa3b5dda0eb46e6371bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b414418e73f90f291f356c7539953cd90653756996c733f94c0963b498cbd68f"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
