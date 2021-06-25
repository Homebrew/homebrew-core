class MCli < Formula
  desc "Swiss Army Knife for macOS"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "623be61aebf074754b148e725933aebe205fbf2d7d2ea3854a8aa6054ea3307e"
  license "MIT"
  head "https://github.com/rgcr/m-cli.git"

  depends_on :macos

  def install
    prefix.install Dir["*"]
    inreplace prefix/"m" do |s|
      # Use absolute rather than relative path to plugins.
      s.gsub!(/^\[ -L.*|^\s+\|\| pushd.*|^popd.*/, "")
      s.gsub!(/MPATH=.*/, "MPATH=#{prefix}")
      # Disable options "update" && "uninstall", they must be handled by brew
      s.gsub!(/update_mcli &&.*/, "printf \"Try: brew update && brew upgrade m-cli \\n\" && exit 0")
      s.gsub!(/uninstall_mcli &&.*/, "printf \"Try: brew uninstall m-cli \\n\" && exit 0")
    end

    bin.install_symlink "#{prefix}/m" => "m"
    bash_completion.install prefix/"completion/bash/m"
    zsh_completion.install prefix/"completion/zsh/_m"
    fish_completion.install prefix/"completion/fish/m.fish"
  end

  test do
    output = pipe_output("#{bin}/m help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*Swiss Army Knife for macOS.*/, output)
  end
end
