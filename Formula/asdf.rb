class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://github.com/asdf-vm"
  url "https://github.com/asdf-vm/asdf/archive/v0.3.0.tar.gz"
  sha256 "1d986789bfcbef76dc23cc968ca192a03862a9496df65e7cd5d6f8117bc85789"

  bottle :unneeded

  depends_on "coreutils" => :run
  depends_on "automake" => :run
  depends_on "autoconf" => :run
  depends_on "openssl" => :run
  depends_on "libyaml" => :run
  depends_on "readline" => :run
  depends_on "libtool" => :run
  depends_on "unixodbc" => :run

  def install
    bash_completion.install "completions/asdf.bash"
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    #########################################

    Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)

         source #{prefix}/asdf.sh

    #########################################
    EOS
  end

  test do
    system "#{bin}/asdf", "plugin-list"
  end
end
