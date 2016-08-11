class GitFlowAvh < Formula
  desc "AVH edition of git-flow"
  homepage "https://github.com/petervanderdoes/gitflow-avh"

  stable do
    url "https://github.com/petervanderdoes/gitflow-avh/archive/1.10.0.tar.gz"
    sha256 "e9c25a500eec3ea6e537a811ed9063e567c5e310caa3ffb274950b744ffcb25a"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion/archive/0.5.2.tar.gz"
      sha256 "7d11d82b9a3c25f7c7189ac61d21a4edb2432435d6138f092f49348bb17917df"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ebb6167d9e3554e12823de72166c26ff8e66918c1acdab3aa2f6a50001555397" => :el_capitan
    sha256 "740023d130705c5041622355d14b4e9d94d7715199be43af7c85b8d4441062e2" => :yosemite
    sha256 "672b121971cf383b4affb5cd4e1fa482a35c4e574f0d22635fef036f1bae312f" => :mavericks
  end

  head do
    url "https://github.com/petervanderdoes/gitflow-avh.git", :branch => "develop"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion.git", :branch => "develop"
    end
  end

  depends_on "gnu-getopt"

  conflicts_with "git-flow"

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
