class Homeshick < Formula
  desc "Git dotfiles synchronizer written in bash"
  homepage "https://github.com/andsens/homeshick"
  url "https://github.com/andsens/homeshick/archive/v1.1.0.tar.gz"
  sha256 "1894675f4f2ab002a97574445c03c7c7336c996c01023b7fc5e6668dce7d5a3c"
  head "https://github.com/andsens/homeshick.git"

  bottle :unneeded

  option "with-fish", "Build fish bindings"
  option "with-csh", "Build csh bindings"

  def install
    inreplace "bin/homeshick", /^homeshick=.*/, "homeshick=#{opt_prefix}"

    prefix.install "lib", "homeshick.sh"
    fish_function.install "homeshick.fish" if build.with? "fish"
    bin.install "bin/homeshick"
    bin.install "bin/homeshick.csh" if build.with? "csh"
    zsh_completion.install "completions/_homeshick"
    bash_completion.install "completions/homeshick-completion.bash"
    if build.head? && build.with?("fish")
      fish_completion.install "completions/homeshick.fish"
    end
  end

  def caveats
    s = <<~EOS
      To enable the `homeshick cd <CASTLE>` command, you need to
      `export HOMESHICK_DIR=#{opt_prefix}`
      and
      `source "#{opt_prefix}/homeshick.sh"`
      in your $HOME/.bashrc
    EOS
    if build.with? "csh"
      s += <<~EOS
        and
        `alias homeshick source "#{opt_bin}/homeshick.csh"`
        in your $HOME/.cshrc
      EOS
    end
    s
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
