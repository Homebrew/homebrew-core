class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/v0.8.0.tar.gz"
  sha256 "9b667ca135c194f38d823c62cc0dc3dbe00d7a9f60caa0c06ecb3047944eadfa"
  license "MIT"
  revision 2
  head "https://github.com/asdf-vm/asdf.git"

  bottle :unneeded
  depends_on "coreutils"
  depends_on "git"

  def install
    bash_completion.install "completions/asdf.bash"
    fish_completion.install "completions/asdf.fish"
    zsh_completion.install "completions/_asdf"
    libexec.install Dir["*"]
    touch libexec/"asdf_updates_disabled"
    bin.write_exec_script (opt_libexec/"bin/asdf")
  end

  def post_install
    system bin/"asdf", "reshim"
  end

  test do
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "Oohes nooes ~! No plugins installed", output
    assert_match "Update command disabled.", shell_output("#{bin}/asdf update", 42)
  end
end
