class GitFlowCjs < Formula
  desc "CJS edition of git-flow"
  homepage "https://github.com/CJ-Systems/gitflow-cjs"
  license "BSD-2-Clause"

  stable do
    url "https://github.com/CJ-Systems/gitflow-cjs/archive/refs/tags/v2.2.0.tar.gz"
    sha256 "e545afd143ce2ac61d4fb1a6d68046eee9b827363009c5aa6db0bf4267a57f08"

    resource "completion" do
      url "https://github.com/CJ-Systems/git-flow-completion/archive/0.6.0.tar.gz"
      sha256 "b1b78b785aa2c06f81cc29fcf03a7dfc451ad482de67ca0d89cdb0f941f5594b"
    end
  end

  head do
    url "https://github.com/CJ-Systems/gitflow-cjs.git", branch: "develop"

    resource "completion" do
      url "https://github.com/CJ-Systems/git-flow-completion.git", branch: "develop"
    end
  end

  depends_on "gnu-getopt"

  conflicts_with "git-flow", "git-flow-avh", because: "both install `git-flow` binaries and completions"

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
      fish_completion.install "git.fish" => "git-flow.fish"
    end
  end

  test do
    system "git", "init"
    system "#{bin}/git-flow", "init", "-d"
    system "#{bin}/git-flow", "config"
    assert_equal "develop", shell_output("git symbolic-ref --short HEAD").chomp
  end
end
