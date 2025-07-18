class MCli < Formula
  desc "Swiss Army Knife for macOS"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "03da227d3627811dcc037c184cf338af2fa4b60461ee7bf10ab94effd38132a0"
  license "MIT"
  head "https://github.com/rgcr/m-cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6c34603cd51adaa1e6dabc3c9ca533b2b72e2eb2a0626ecbac725b04428a4f7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16476d5b167268a327662d0aa26bf9c46aaf41bba5b08527f862b9ef2ce14034"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dad744034a6378e1cac4bf308ed7b85beab6036667a4e1bed74842f095857ce6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dad811c6cd0ca58a310fe482101f036bfcfe99e4675bf0682b6736db7e3d8a80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57f125ffaf0e6a50c2d820b23921c4d804349a51df9780e00f79f4a41b9e4e39"
    sha256 cellar: :any_skip_relocation, sonoma:         "effe750906370768f69a1705deff0e41f2eca0f53b9399a0cb3842a222773f51"
    sha256 cellar: :any_skip_relocation, ventura:        "c19300f8154066b9e1f9fecf8ba3dd0f423bedfd25dd5573b0255bda0f9a635a"
    sha256 cellar: :any_skip_relocation, monterey:       "a2def96834871cfd7618f2186662afdf5ef52f0c909b19d2d3b98cd4193fbd6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5131627ba06d37f0e1512cd3bbc7cda2c696deec07a3495c98974553ba900fa9"
    sha256 cellar: :any_skip_relocation, catalina:       "5131627ba06d37f0e1512cd3bbc7cda2c696deec07a3495c98974553ba900fa9"
    sha256 cellar: :any_skip_relocation, mojave:         "5131627ba06d37f0e1512cd3bbc7cda2c696deec07a3495c98974553ba900fa9"
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
      s.gsub!(/^\s*set plugins_dir "\$script_dir\/plugins"$/,
              "set plugins_dir \"#{prefix}/plugins\"")
    end

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
