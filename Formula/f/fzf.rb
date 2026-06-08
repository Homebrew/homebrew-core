class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.73.1.tar.gz"
  sha256 "ae4f49f8606a7d28498208fa1b93c5d3b890719eea97e02559e66160138b750c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fa0b080ba98e6623c45fc44f149c7b10203f00c76df512ad6e7ef28996edaea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fa0b080ba98e6623c45fc44f149c7b10203f00c76df512ad6e7ef28996edaea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fa0b080ba98e6623c45fc44f149c7b10203f00c76df512ad6e7ef28996edaea"
    sha256 cellar: :any_skip_relocation, sonoma:        "88bfd644209e526508b628142543a755008ca00a9d54116f4f679eea835d0c67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20c5aa7cf606cdb123a56ae08b67ad6fe3ef50f6eb2523e358357454f5a05a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9cc75073e76c383b51e28d7549be331ed670c681c588d9b8169e0e2536af7d"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
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
