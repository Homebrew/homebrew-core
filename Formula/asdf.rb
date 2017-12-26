class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://github.com/asdf-vm"
  url "https://github.com/asdf-vm/asdf/archive/v0.4.1.tar.gz"
  sha256 "09f75fa8afa4efc043af2d90b8b1e3f0f3387cbe9ade42b5c043dee96ae23ef9"

  bottle :unneeded

  depends_on "autoconf" => :run
  depends_on "automake" => :run
  depends_on "libtool" => :run
  depends_on "coreutils"
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
    system "#{bin}/asdf", "plugin-list"
  end
end
