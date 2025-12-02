class Nodebrew < Formula
  desc "Node.js version manager"
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6d72e39c8acc5b22f4fc7a1734cd3bb8d00b61119ab7fea6cde376810ff2005e"
  license "MIT"
  head "https://github.com/hokaccha/nodebrew.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bd835b02ed3b28570708b7c98d0ea7a761c53f561544496d07728c9adf3502e2"
  end

  def install
    bin.install "nodebrew"
    bash_completion.install "completions/bash/nodebrew-completion" => "nodebrew"
    zsh_completion.install "completions/zsh/_nodebrew"
  end

  def caveats
    <<~EOS
      You need to manually run setup_dirs to create directories required by nodebrew:
        #{opt_bin}/nodebrew setup_dirs

      Add path:
        export PATH=$HOME/.nodebrew/current/bin:$PATH

      To use Homebrew's directories rather than ~/.nodebrew add to your profile:
        export NODEBREW_ROOT=#{var}/nodebrew
    EOS
  end

  test do
    assert_match "v0.10.0", shell_output("#{bin}/nodebrew ls-remote")
  end
end
