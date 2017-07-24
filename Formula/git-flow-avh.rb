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
    sha256 "33e03f83ebcf7f30f2fb8bd51b81449c34a40b0e83d0624ee447d91f186f27dd" => :sierra
    sha256 "7e66cfac66122d10749ae8560bf055eb45dc11b54f61f1a35bd97baea348f15f" => :el_capitan
    sha256 "7e66cfac66122d10749ae8560bf055eb45dc11b54f61f1a35bd97baea348f15f" => :yosemite
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
    (bin/"git-flow").write <<-EOS.undent
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
