class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "d0cafe61d27b5e3fcb53658821bfbf744fd040a8ea28b0e22277e032b8e8f7fe"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a94dd362ce5c3a818f4fa56607eac3c616a3c1191e9f41480093bda2dc308af4"
  end

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    bash_completion.install "completions/asdf.bash" => "asdf"
    fish_completion.install "completions/asdf.fish"
    zsh_completion.install "completions/_asdf"
    libexec.install Dir["*"]

    bin.write_exec_script libexec/"bin/asdf"
  end

  def caveats
    <<~EOS
      To use asdf, add the following line (or equivalent) to your shell profile
      e.g. ~/.profile or ~/.zshrc:
        . #{opt_libexec}/asdf.sh
      e.g. ~/.config/fish/config.fish
        source #{opt_libexec}/asdf.fish
      Restart your terminal for the settings to take effect.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    output = shell_output("#{bin}/asdf plugin-list 2>&1")
    assert_match "No plugins installed", output
  end
end
