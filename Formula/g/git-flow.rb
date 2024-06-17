class GitFlow < Formula
  desc "Extensions to follow Vincent Driessen's branching model"
  homepage "https://github.com/nvie/gitflow"
  license "BSD-2-Clause"
  revision 1

  stable do
    # Use the tag instead of the tarball to get submodules
    url "https://github.com/nvie/gitflow.git",
        tag:      "0.4.1",
        revision: "1ffb6b1091f05466d3cd27f2da9c532a38586ed5"

    resource "completion" do
      url "https://github.com/bobthecow/git-flow-completion/archive/refs/tags/0.4.2.2.tar.gz"
      sha256 "1e82d039596c0e73bfc8c59d945ded34e4fce777d9b9bb45c3586ee539048ab9"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cffa267a59238174b54b4058131b3fdf674d4fa79ff724dd7111f6bc7730c40f"
  end

  head do
    url "https://github.com/nvie/gitflow.git", branch: "develop"

    resource "completion" do
      url "https://github.com/bobthecow/git-flow-completion.git", branch: "develop"
    end
  end

  conflicts_with "git-flow-avh", because: "both install `git-flow` binaries and completions"

  def install
    system "make", "prefix=#{libexec}", "install"
    bin.write_exec_script libexec/"bin/git-flow"
    resource("completion").stage do
      # Fix a comment referencing `/usr/local` that causes deviations between bottles.
      inreplace "git-flow-completion.bash", "/usr/local", HOMEBREW_PREFIX
      bash_completion.install "git-flow-completion.bash"
    end
  end

  def caveats
    <<~EOS
      To install Zsh completions:
        brew install zsh-completions
    EOS
  end

  test do
    system "git", "flow", "init", "-d"
    assert_equal "develop", shell_output("git rev-parse --abbrev-ref HEAD").strip
  end
end
