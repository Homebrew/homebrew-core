class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://github.com/asdf-vm"
  url "https://github.com/asdf-vm/asdf/archive/v0.7.4.tar.gz"
  sha256 "25c3c26e667eaf96686db340279acfa1b40a924ed2ecabc4db66a04b12211f7e"
  head "https://github.com/asdf-vm/asdf.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "unixodbc"

  conflicts_with "homeshick",
    :because => "asdf and homeshick both install files in lib/commands"

  def install
    bash_completion.install "completions/asdf.bash"
    fish_completion.install "completions/asdf.fish"
    libexec.install "bin/private"
    prefix.install Dir["*"]
  end

  test do
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "Oohes nooes ~! No plugins installed", output
  end
end
