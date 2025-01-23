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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5d033f268e63aa92c1561995bbaad9708c08239a21c8f243583f5a804134a659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8122f64f75d8a8560dcee7f34d83d9c994c10a51fcd93a4f543d52d002a9933c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8122f64f75d8a8560dcee7f34d83d9c994c10a51fcd93a4f543d52d002a9933c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8122f64f75d8a8560dcee7f34d83d9c994c10a51fcd93a4f543d52d002a9933c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d112ed09a9a2de61146ec0e937f95024948b3059bb9abe974da0d7596ddb86fd"
    sha256 cellar: :any_skip_relocation, ventura:        "d112ed09a9a2de61146ec0e937f95024948b3059bb9abe974da0d7596ddb86fd"
    sha256 cellar: :any_skip_relocation, monterey:       "1fdf81e178b50812b6aa615a8621e307a3df93f79cbbfbcb3cd2584a51a32084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8122f64f75d8a8560dcee7f34d83d9c994c10a51fcd93a4f543d52d002a9933c"
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
