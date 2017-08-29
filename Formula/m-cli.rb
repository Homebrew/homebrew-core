class MCli < Formula
  desc "Swiss Army Knife for macOS"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/v0.2.4.tar.gz"
  sha256 "1afbb46bc63fee59331c2b89d2926cbc27b3bd2671bbeedb6c9c309c582657f2"
  head "https://github.com/rgcr/m-cli.git"

  bottle :unneeded

  def install
    prefix.install Dir["*"]
    inreplace prefix/"m" do |s|
      # Use absolute rather than relative path to plugins.
      s.gsub! /^\[ -L.*|^\s+\|\| pushd.*|^popd.*/, ""
      s.gsub! /MPATH=.*/, "MPATH=#{prefix}"
      # Disable options "update" && "uninstall", they must be handled by brew
      s.gsub! /update_mcli \&\&.*/, "printf \"Try: brew update && brew upgrade m-cli \\n\" && exit 0"
      s.gsub! /uninstall_mcli \&\&.*/, "printf \"Try: brew uninstall m-cli \\n\" && exit 0"
    end

    bin.install_symlink "#{prefix}/m" => "m"
    bash_completion.install prefix/"completion/bash/m"
    zsh_completion.install prefix/"completion/zsh/_m"
    fish_completion.install prefix/"completion/fish/m.fish"
  end

  test do
    output = pipe_output("#{bin}/m help 2>&1")
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*Swiss Army Knife for macOS.*/, output
  end
end
