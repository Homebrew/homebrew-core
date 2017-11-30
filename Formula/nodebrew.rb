class Nodebrew < Formula
  desc "Node.js version manager"
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/v0.9.8.tar.gz"
  sha256 "040c1b32ddce6d83fda76a50ce9bc635ce0040f76a63617d74234449b8ff078b"
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
