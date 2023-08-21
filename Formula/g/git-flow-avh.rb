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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f559b035f16d9f56bb1750bfd441785df1f094a3838b20c1c51503cc75c2f319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f559b035f16d9f56bb1750bfd441785df1f094a3838b20c1c51503cc75c2f319"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f559b035f16d9f56bb1750bfd441785df1f094a3838b20c1c51503cc75c2f319"
    sha256 cellar: :any_skip_relocation, ventura:        "fe31ea33fecc7177f22fa64b15430512ea2ae728536d3c3d21b9121d97e311e6"
    sha256 cellar: :any_skip_relocation, monterey:       "fe31ea33fecc7177f22fa64b15430512ea2ae728536d3c3d21b9121d97e311e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe31ea33fecc7177f22fa64b15430512ea2ae728536d3c3d21b9121d97e311e6"
    sha256 cellar: :any_skip_relocation, catalina:       "fe31ea33fecc7177f22fa64b15430512ea2ae728536d3c3d21b9121d97e311e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f559b035f16d9f56bb1750bfd441785df1f094a3838b20c1c51503cc75c2f319"
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
