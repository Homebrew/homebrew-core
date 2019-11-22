class GitFlowAvh < Formula
  desc "AVH edition of git-flow"
  homepage "https://github.com/petervanderdoes/gitflow-avh"

  stable do
    url "https://github.com/petervanderdoes/gitflow-avh/archive/1.12.3.tar.gz"
    sha256 "54e9fd81aa1aa8215c865503dc6377da205653c784d6c97baad3dafd20728e06"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion/archive/0.6.0.tar.gz"
      sha256 "b1b78b785aa2c06f81cc29fcf03a7dfc451ad482de67ca0d89cdb0f941f5594b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d9d8011ee6b4167e321077e44c0e99485a80f8bc1f294390495231c392d1bbba" => :catalina
    sha256 "945e9ba05a169b32c86f5bd347542e803625791cf9a4b50a4a42fafb5e0b9c85" => :mojave
    sha256 "945e9ba05a169b32c86f5bd347542e803625791cf9a4b50a4a42fafb5e0b9c85" => :high_sierra
    sha256 "0e68b196dd24d9d41f9b0c5545d115c9ca8327dd799facbed2e619f8ceea221b" => :sierra
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
