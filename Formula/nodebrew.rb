class Nodebrew < Formula
  desc "Node.js version manager"
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/v0.9.5.tar.gz"
  sha256 "9b0b1e9e6fb6cc96933fba73f7dbf2c9621ac75ddd4f339d993571de5ca0e216"
  head "https://github.com/hokaccha/nodebrew.git"

  bottle :unneeded

  def install
    bin.install "nodebrew"
    system "#{bin}/nodebrew", "setup_dirs"
    bash_completion.install "completions/bash/nodebrew-completion" => "nodebrew"
    zsh_completion.install "completions/zsh/_nodebrew"
  end

  def caveats; <<-EOS.undent
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
