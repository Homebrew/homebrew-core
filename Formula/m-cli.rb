class MCli < Formula
  desc "Swiss Army Knife for macOS"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "623be61aebf074754b148e725933aebe205fbf2d7d2ea3854a8aa6054ea3307e"
  license "MIT"
  head "https://github.com/rgcr/m-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dad811c6cd0ca58a310fe482101f036bfcfe99e4675bf0682b6736db7e3d8a80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57f125ffaf0e6a50c2d820b23921c4d804349a51df9780e00f79f4a41b9e4e39"
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
