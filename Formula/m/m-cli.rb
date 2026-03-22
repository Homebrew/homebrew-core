class MCli < Formula
  desc "Swiss Army Knife for macOS"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "38c55e845ecea36a4b8fad02232014823bd38099c67d2f40b6dbbc4e63a64806"
  license "MIT"
  head "https://github.com/rgcr/m-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "be6e119c88c80d133735f628de0bf47be59ff170e9b2f20888df8ea0ea419b98"
  end

  depends_on :macos

  def install
    prefix.install Dir["*"]

    inreplace prefix/"m" do |s|
      # Use absolute rather than relative path to plugins.
      s.sub!(/^MCLI_PATH=.+$/, "MCLI_PATH=#{prefix}")
      # Disable options "update" && "uninstall", they must be handled by brew
      s.sub!(/^\s*update_mcli\s*&&.*/,
             'printf "\'m-cli\' was installed by brew, try: brew update && brew upgrade m-cli\n" && exit 0')
      s.sub!(/^\s*uninstall_mcli\s*&&.*/,
             'printf "\'m-cli\' was installed by brew, try: brew uninstall m-cli\n" && exit 0')
      s.sub!(/^\s*get_version\s*&&.*/,
             "printf \"m-cli version: v#{version}\\n\" && exit 0")
    end

    inreplace prefix/"completions/bash/m" do |s|
      # Use absolute brew path for bash completion
      s.sub!(/^\s*local PLUGINS_DIR=.+$/, "local PLUGINS_DIR=#{prefix}/plugins")
    end

    inreplace prefix/"completions/zsh/_m" do |s|
      # Use absolute brew path for zsh completion
      s.sub!(/^\s*local PLUGINS_DIR=.+$/, "local PLUGINS_DIR=#{prefix}/plugins")
    end

    inreplace prefix/"completions/fish/m.fish" do |s|
      # Use absolute brew path for fish completion
      s.gsub!(%r{^\s*set plugins_dir "\$script_dir/plugins"$},
              "set plugins_dir \"#{prefix}/plugins\"")
    end

    # Remove the install script, it is not needed
    (prefix/"install.sh").unlink if (prefix/"install.sh").exist?

    bin.install_symlink "#{prefix}/m" => "m"
    bash_completion.install prefix/"completions/bash/m"
    zsh_completion.install prefix/"completions/zsh/_m"
    fish_completion.install prefix/"completions/fish/m.fish"
  end

  test do
    output = pipe_output("#{bin}/m --help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*Swiss Army Knife for macOS.*/, output)
  end
end
