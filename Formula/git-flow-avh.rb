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
    sha256 "ba58968f480cccdcfcbbdc5e669c01a96db5ff2aece0e9a9839199261e3d5af9" => :el_capitan
    sha256 "b33247f97c664963dbeccadc87922ca5fef9fed894094f4ca4caaf78d5aa77a5" => :yosemite
    sha256 "6c3911763f46160042913cb6d4d5d755dd59a7a62c9edc7b62d7932a43402236" => :mavericks
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
