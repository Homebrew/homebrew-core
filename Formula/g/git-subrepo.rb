class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/refs/tags/0.4.9.tar.gz"
  sha256 "6e4784d9739a9153377d4a00bd3256618eee732ee988b85b4c70f1ba48566458"
  license "MIT"
  head "https://github.com/ingydotnet/git-subrepo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2b36a28dabe54ae8570223cf276739f8692c3ca72b28e96fcd2f74a819a46736"
  end

  depends_on "bash"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin" if OS.mac?

    libexec.mkpath
    system "make", "PREFIX=#{prefix}", "INSTALL_LIB=#{libexec}", "install"
    bin.install_symlink libexec/"git-subrepo"

    mv "share/completion.bash", "share/git-subrepo"
    bash_completion.install "share/git-subrepo"
    zsh_completion.install "share/zsh-completion/_git-subrepo"
  end

  test do
    mkdir "mod" do
      system "git", "init"
      touch "HELLO"
      system "git", "add", "HELLO"
      system "git", "commit", "-m", "testing"
    end

    mkdir "container" do
      system "git", "init"
      touch ".gitignore"
      system "git", "add", ".gitignore"
      system "git", "commit", "-m", "testing"

      assert_match(/cloned into/,
                   shell_output("git subrepo clone ../mod mod"))
    end
  end
end
