class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.39.0.tar.gz"
  sha256 "ac665ac269eca320ca9268227142f01b10ad5d25364ff274658b5a9f709a7259"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86c52189ff81f6a06aa0c10a0001c79deec1caef8e3c1352306f1d7f14333fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c52189ff81f6a06aa0c10a0001c79deec1caef8e3c1352306f1d7f14333fe1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86c52189ff81f6a06aa0c10a0001c79deec1caef8e3c1352306f1d7f14333fe1"
    sha256 cellar: :any_skip_relocation, ventura:        "6bf71cf266174aecd01cfe4b9dca48117b40fca533e0f32d8bacd6a38b547254"
    sha256 cellar: :any_skip_relocation, monterey:       "6bf71cf266174aecd01cfe4b9dca48117b40fca533e0f32d8bacd6a38b547254"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bf71cf266174aecd01cfe4b9dca48117b40fca533e0f32d8bacd6a38b547254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0eede24654216cb55846976d8f79532d97734a2c22dfee393f060db91f48795"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats
    <<~EOS
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end
