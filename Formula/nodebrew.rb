class Nodebrew < Formula
  desc "Node.js version manager"
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/v1.0.1.tar.gz"
  sha256 "c34e7186d4fd493c5417ad5563ad39fd493a42695bd9a7758c3df10380e43399"
  head "https://github.com/hokaccha/nodebrew.git"

  bottle :unneeded

  def install
    bin.install "nodebrew"
    bash_completion.install "completions/bash/nodebrew-completion" => "nodebrew"
    zsh_completion.install "completions/zsh/_nodebrew"
  end

  def caveats; <<~EOS
    You need to manually run setup_dirs to create directories required by nodebrew:
      #{opt_bin}/nodebrew setup_dirs

    Add path:
      export PATH=$HOME/.nodebrew/current/bin:$PATH

    To use Homebrew's directories rather than ~/.nodebrew add to your profile:
      export NODEBREW_ROOT=#{var}/nodebrew
  EOS
  end

  test do
    assert_match /v0.10.0/, shell_output("#{bin}/nodebrew ls-remote")
  end
end
