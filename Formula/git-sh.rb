class GitSh < Formula
  desc "Customized Bash environment for git work"
  homepage "https://github.com/rtomayko/git-sh"
  url "https://github.com/rtomayko/git-sh/archive/1.3.tar.gz"
  sha256 "461848dfa52ea6dd6cd0a374c52404b632204dc637cde17c0532529107d52358"

  head "https://github.com/rtomayko/git-sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d371fba61367507f5e88818eb1f0630e388d198c37faa957ce410d97675a7f5d" => :sierra
    sha256 "e30e7836919a5d79712e3fd51a118279b412c44da909053b9b185eb48963323f" => :el_capitan
    sha256 "cdbc6fc62300722f613f314e2859422edcf938c6807a3039bcf476e02fbe222c" => :yosemite
    sha256 "1b9aa141f32145516db62304dda799611e1fc35ec57275ee75bf566325a6bfa5" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/git-sh", "-c", "ls"
  end
end
