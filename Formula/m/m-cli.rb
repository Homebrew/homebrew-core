class MCli < Formula
  desc "Swiss Army Knife for macOS"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "506fc6fe4ae4500607aad3b56af2e1af3dfb1c67332472b3a85950a2dab53ef9"
  license "MIT"
  head "https://github.com/rgcr/m-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "81c1152ababf9d2211b86c4f6bb58f767d128c2e03bd1d720166404e7c3ccec1"
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
             "printf \"m-cli version: v2.0.4\\n\" && exit 0")
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
