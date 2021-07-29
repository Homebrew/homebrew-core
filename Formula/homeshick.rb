class Homeshick < Formula
  desc "Git dotfiles synchronizer written in bash"
  homepage "https://github.com/andsens/homeshick"
  url "https://github.com/andsens/homeshick/archive/v2.0.0.tar.gz"
  sha256 "14a538bfc2e7cb6bfd35c984cdedbf3d3293413a70cc67f685dbfbd33ce64fdd"
  license "MIT"
  head "https://github.com/andsens/homeshick.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61abfc0f6d5e42bf58f6b15eaeb155e867094b5d3cd33f88223d0ec7882106fa"
  end

  def install
    inreplace "bin/homeshick", /^homeshick=.*/, "homeshick=#{opt_prefix}"

    prefix.install "lib", "homeshick.sh"
    fish_function.install "homeshick.fish"
    bin.install "bin/homeshick"
    zsh_completion.install "completions/_homeshick"
    bash_completion.install "completions/homeshick-completion.bash"
    fish_completion.install "completions/homeshick.fish" if build.head?
  end

  def caveats
    <<~EOS
      To enable the `homeshick cd <CASTLE>` command, you need to
        `export HOMESHICK_DIR=#{opt_prefix}`
      and
        `source "#{opt_prefix}/homeshick.sh"`
      in your $HOME/.bashrc
    EOS
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/sh
      export HOMESHICK_DIR="#{opt_prefix}"
      source "#{opt_prefix}/homeshick.sh"
      homeshick generate test
      homeshick list
    EOS
    assert_match "test", shell_output("bash #{testpath}/test.sh")
  end
end
