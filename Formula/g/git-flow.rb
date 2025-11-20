class GitFlow < Formula
  desc "Extensions to follow Vincent Driessen's branching model"
  homepage "https://github.com/nvie/gitflow"
  license "BSD-2-Clause"
  revision 1

  stable do
    # submodule checkout has some issue, `git://` protocol has been deprecated
    # https://github.blog/security/application-security/improving-git-protocol-security-github/
    # upstream build issue report, https://github.com/nvie/gitflow/issues/6490
    url "https://github.com/nvie/gitflow/archive/refs/tags/0.4.1.tar.gz"
    sha256 "c1271b0ba2c6655e4ad4d79562f6a910c3b884f3d4e16985e227e67f8d95c180"

    resource "shFlags" do
      url "https://github.com/nvie/shFlags.git",
          revision: "2fb06af13de884e9680f14a00c82e52a67c867f1"
    end

    resource "completion" do
      url "https://github.com/bobthecow/git-flow-completion/archive/refs/tags/0.4.2.2.tar.gz"
      sha256 "1e82d039596c0e73bfc8c59d945ded34e4fce777d9b9bb45c3586ee539048ab9"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "053355d898d7f3c171eec04b984fb2f4e06588b7ef58dd8f6024c5300933d27a"
  end

  head do
    url "https://github.com/nvie/gitflow.git", branch: "develop"

    resource "shFlags" do
      url "https://github.com/nvie/shFlags.git", branch: "master"
    end

    resource "completion" do
      url "https://github.com/bobthecow/git-flow-completion.git", branch: "develop"
    end
  end

  def install
    (buildpath/"shFlags").install resource("shFlags")

    system "make", "prefix=#{libexec}", "install"
    bin.write_exec_script libexec/"bin/git-flow"
    resource("completion").stage do
      # Fix a comment referencing `/usr/local` that causes deviations between bottles.
      inreplace "git-flow-completion.bash", "/usr/local", HOMEBREW_PREFIX
      bash_completion.install "git-flow-completion.bash" => "git-flow"
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
