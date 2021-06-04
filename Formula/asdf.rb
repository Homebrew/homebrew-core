class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/v0.8.1.tar.gz"
  sha256 "6ca280287dcb687ec12f0c37e4e193de390cdab68f2b2a0e271e3a4f1e20bd2e"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c294611358559bc924cafddd4bc8693fa5d86398366c73a3abbbbca28ffdc777"
  end

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "unixodbc"

  conflicts_with "homeshick",
    because: "asdf and homeshick both install files in lib/commands"

  def install
    bash_completion.install "completions/asdf.bash"
    fish_completion.install "completions/asdf.fish"
    zsh_completion.install "completions/_asdf"
    libexec.install "bin/private"
    prefix.install Dir["*"]
    touch prefix/"asdf_updates_disabled"
  end

  test do
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "No plugins installed", output
    assert_match "Update command disabled.", shell_output("#{bin}/asdf update", 42)
  end
end
