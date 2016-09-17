class GitFlowAvh < Formula
  desc "AVH edition of git-flow"
  homepage "https://github.com/petervanderdoes/gitflow-avh"

  stable do
    url "https://github.com/petervanderdoes/gitflow-avh/archive/1.10.2.tar.gz"
    sha256 "09b9de0790276cbff2906c31193bdac859235a0cdfb56cedd13b4a1a4ee75065"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion/archive/0.5.2.tar.gz"
      sha256 "7d11d82b9a3c25f7c7189ac61d21a4edb2432435d6138f092f49348bb17917df"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6797fda1e035ee79a34615be08479332f084ae039ea91d0201d444a0c02ae7f0" => :sierra
    sha256 "e5ab7eb651c686fe232a5290f876bb8ef6fa2709c6fc97824e0d917ec3237ba6" => :el_capitan
    sha256 "6797fda1e035ee79a34615be08479332f084ae039ea91d0201d444a0c02ae7f0" => :yosemite
    sha256 "6797fda1e035ee79a34615be08479332f084ae039ea91d0201d444a0c02ae7f0" => :mavericks
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
