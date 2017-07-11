class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://github.com/asdf-vm"
  url "https://github.com/asdf-vm/asdf/archive/v0.3.0.tar.gz"
  sha256 "1d986789bfcbef76dc23cc968ca192a03862a9496df65e7cd5d6f8117bc85789"

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

    inreplace "#{lib}/commands/reshim.sh", "exec $(asdf_dir)/bin/private/asdf-exec ", "exec $(asdf_dir)/libexec/private/asdf-exec "
  end

  def caveats; <<-EOS.undent
    Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)
         source #{prefix}/asdf.sh

    If you use Fish shell, add the following line to your fish config (e.g. ~/.config/fish/config.fish)
         source #{prefix}/asdf.fish
    EOS
  end

  test do
    system "#{bin}/asdf", "plugin-list"
  end
end
