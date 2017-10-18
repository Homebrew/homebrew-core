class GitFlowAvh < Formula
  desc "AVH edition of git-flow"
  homepage "https://github.com/petervanderdoes/gitflow-avh"
  revision 1

  stable do
    url "https://github.com/petervanderdoes/gitflow-avh/archive/1.11.0.tar.gz"
    sha256 "06ad2110088e46e3712f799a43bf6cc5c3720fc25c69dbb3bbf4cf486cf2f330"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion/archive/0.6.0.tar.gz"
      sha256 "b1b78b785aa2c06f81cc29fcf03a7dfc451ad482de67ca0d89cdb0f941f5594b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e48230e7b1bfd53aba1608167e607c3fc9792b05bd3063ef5bb47bebbdb9ddc5" => :high_sierra
    sha256 "f54736764e21c714e51cab2bb2bda7d8f775fabe6575f57cf31d02ba4f57a673" => :sierra
    sha256 "f54736764e21c714e51cab2bb2bda7d8f775fabe6575f57cf31d02ba4f57a673" => :el_capitan
    sha256 "f54736764e21c714e51cab2bb2bda7d8f775fabe6575f57cf31d02ba4f57a673" => :yosemite
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
    end
  end

  test do
    system "git", "init"
    system "#{bin}/git-flow", "init", "-d"
    system "#{bin}/git-flow", "config"
    assert_equal "develop", shell_output("git symbolic-ref --short HEAD").chomp
  end
end
