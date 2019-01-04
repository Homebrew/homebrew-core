class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://github.com/asdf-vm"
  url "https://github.com/asdf-vm/asdf/archive/v0.6.2.tar.gz"
  sha256 "5d8c19c311206f5ea4a3a4a978bc5140924d6faf4880dfb7f68cdf1077f036e6"
  head "https://github.com/asdf-vm/asdf.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    bash_completion.install "completions/asdf.bash"
    fish_completion.install "completions/asdf.fish"
    libexec.install "bin/private"
    prefix.install Dir["*"]

    inreplace "#{lib}/commands/reshim.sh",
              "exec $(asdf_dir)/bin/private/asdf-exec ",
              "exec $(asdf_dir)/libexec/private/asdf-exec "
  end

  def caveats; <<~EOS
    Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)
    If you are using a framework, such as oh-my-zsh, place them at the end of your .zshrc
        . $HOME/.asdf/asdf.sh
        . $HOME/.asdf/completions/asdf.bash

    If you use Fish shell, add the following line to your fish config (e.g. ~/.config/fish/config.fish)
         source #{opt_prefix}/asdf.fish

    You will also need to update the fish completions by running the following:
      mkdir -p ~/.config/fish/completions
      cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions
  EOS
  end

  test do
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "Oohes nooes ~! No plugins installed", output
  end
end
