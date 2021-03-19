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
    (prefix/"asdf.sh").write ". #{opt_libexec}/asdf.sh\n"
    (prefix/"asdf.fish").write "source #{opt_libexec}/asdf.fish\n"
  end

  def post_install
    system bin/"asdf", "reshim"
  end

  def caveats
    <<~EOS
      Add shims in $PATH by having the following line your ~/.zshenv or #{shell_profile}:
        export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
      If you use Fish shell add the following line to your ~/.config/fish/config.fish:
      	set PATH (
		      if test -n "$ASDF_DATA_DIR"
		        echo $ASDF_DATA_DIR/shims
		      else
		        echo $HOME/.asdf/shims
		      end
		    ) $PATH

      To support package version per session using asdf shell <name> <version>
	      Add the following line to your #{shell_profile} file:
    	    . #{opt_libexec}/lib/asdf.sh
	      If you use Fish shell add the following line to your ~/.config/fish/config.fish:
    	    source #{opt_libexec}/lib/asdf.fish
      Restart your terminal for the settings to take effect.
    EOS
  end

  test do
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "Oohes nooes ~! No plugins installed", output
    assert_match "Update command disabled.", shell_output("#{bin}/asdf update", 42)
  end
end
