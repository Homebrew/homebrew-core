class GitFlowAvh < Formula
  desc "AVH edition of git-flow"
  homepage "https://github.com/petervanderdoes/gitflow-avh"

  stable do
    url "https://github.com/petervanderdoes/gitflow-avh/archive/1.12.0.tar.gz"
    sha256 "3de0d33376fbbfa11d0a0f7d49e2d743f322ff89920c070593b2bbb4187f2af5"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion/archive/0.6.0.tar.gz"
      sha256 "b1b78b785aa2c06f81cc29fcf03a7dfc451ad482de67ca0d89cdb0f941f5594b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "40d9fbe7b2edc783565efe4d7fa5842fb8e855dbb9d6af8871cec797ff84fd14" => :mojave
    sha256 "d1f0b434f4931a703155c274daad453f3c6f75122f42090d0c6231ef62365dc9" => :high_sierra
    sha256 "d1f0b434f4931a703155c274daad453f3c6f75122f42090d0c6231ef62365dc9" => :sierra
  end

  head do
    url "https://github.com/petervanderdoes/gitflow-avh.git", :branch => "develop"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion.git", :branch => "develop"
    end
  end

  depends_on "gnu-getopt"

  conflicts_with "git-flow", :because => "Both install `git-flow` binaries and completions"

  def install
    system "make", "prefix=#{libexec}", "install"
    (bin/"git-flow").write <<~EOS
      #!/bin/bash
      export FLAGS_GETOPT_CMD=#{Formula["gnu-getopt"].opt_bin}/getopt
      exec "#{libexec}/bin/git-flow" "$@"
    EOS

    resource("completion").stage do
      bash_completion.install "git-flow-completion.bash"
      zsh_completion.install "git-flow-completion.zsh"
      fish_completion.install "git.fish"
    end
  end

  test do
    system "git", "init"
    system "#{bin}/git-flow", "init", "-d"
    system "#{bin}/git-flow", "config"
    assert_equal "develop", shell_output("git symbolic-ref --short HEAD").chomp
  end
end
