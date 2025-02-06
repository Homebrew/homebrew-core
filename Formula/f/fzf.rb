class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "72e1f94a74998dfaa38f9b24cabfe7b5c9f9303d8bb895eefbf55095f8f609db"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a5bc7c9c070941a8d4607f52e53c5b2c72e8ab6d69348a1e50778697b88cc62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a5bc7c9c070941a8d4607f52e53c5b2c72e8ab6d69348a1e50778697b88cc62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a5bc7c9c070941a8d4607f52e53c5b2c72e8ab6d69348a1e50778697b88cc62"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee23755d6d9c18a0150d982095b0c1e80e699bd506bc5896745af6711b17bf83"
    sha256 cellar: :any_skip_relocation, ventura:       "ee23755d6d9c18a0150d982095b0c1e80e699bd506bc5896745af6711b17bf83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c8ee8e8fbbffce1dd86a372f1e8a7a87f853ce520f539c5ff74b4501fc4e2e5"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
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
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end
