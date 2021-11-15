class GitFlowAvh < Formula
  desc "AVH edition of git-flow"
  homepage "https://github.com/petervanderdoes/gitflow-avh"
  license "BSD-2-Clause"

  stable do
    url "https://github.com/petervanderdoes/gitflow-avh/archive/1.12.3.tar.gz"
    sha256 "54e9fd81aa1aa8215c865503dc6377da205653c784d6c97baad3dafd20728e06"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion/archive/0.6.0.tar.gz"
      sha256 "b1b78b785aa2c06f81cc29fcf03a7dfc451ad482de67ca0d89cdb0f941f5594b"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75416cf7069631b648859caefd1efd85ebfec2e4781acfeb4215889460439a69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3b1f734a2df3a919e1f62e8bbcf6a1f3c2a188cfeebce09c7e4f62fdca4242f"
    sha256 cellar: :any_skip_relocation, monterey:       "62e5e3eabc08ca2cfebdaf45e23f2ba04f68906dae71858795bd5db36badd572"
    sha256 cellar: :any_skip_relocation, big_sur:        "908021867768ca0b772288052b4518aeec2e682d2141b6b912c539176a069fce"
    sha256 cellar: :any_skip_relocation, catalina:       "d9d8011ee6b4167e321077e44c0e99485a80f8bc1f294390495231c392d1bbba"
    sha256 cellar: :any_skip_relocation, mojave:         "945e9ba05a169b32c86f5bd347542e803625791cf9a4b50a4a42fafb5e0b9c85"
    sha256 cellar: :any_skip_relocation, high_sierra:    "945e9ba05a169b32c86f5bd347542e803625791cf9a4b50a4a42fafb5e0b9c85"
    sha256 cellar: :any_skip_relocation, sierra:         "0e68b196dd24d9d41f9b0c5545d115c9ca8327dd799facbed2e619f8ceea221b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75416cf7069631b648859caefd1efd85ebfec2e4781acfeb4215889460439a69"
  end

  head do
    url "https://github.com/petervanderdoes/gitflow-avh.git", branch: "develop"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion.git", branch: "develop"
    end
  end

  depends_on "gnu-getopt"

  conflicts_with "git-flow", because: "both install `git-flow` binaries and completions"

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
