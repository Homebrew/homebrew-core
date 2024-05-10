class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8bca30e01e7fdb71d93fe7bc6efc80bfa41f27a3ff584d184138817962be8058"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2aa1302895c8908cef593cd3e9b3be3aea517595c8cd8bcb380cc0474db0bd05"
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
    bash_completion.install "completions/asdf.bash"
    fish_completion.install "completions/asdf.fish"
    zsh_completion.install "completions/_asdf"
    libexec.install Dir["*"]
    touch libexec/"asdf_updates_disabled"

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
    assert_match "Update command disabled.", shell_output("#{bin}/asdf update", 42)
  end
end
