class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://github.com/asdf-vm"
  url "https://github.com/asdf-vm/asdf/archive/v0.6.0.tar.gz"
  sha256 "a17a198b1581fb8f26dadf03985b71287989f0cfc5da40f5c9e1937ec8f9f74b"
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
         source #{opt_prefix}/asdf.sh

    If you use Fish shell, add the following line to your fish config (e.g. ~/.config/fish/config.fish)
         source #{opt_prefix}/asdf.fish
  EOS
  end

  test do
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "Oohes nooes ~! No plugins installed", output
  end
end
