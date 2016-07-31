class MCli < Formula
  desc "Swiss Army Knife for Mac OS X"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/v0.0.9.tar.gz"
  sha256 "957e86c03a8196f60c852672aa0a7c86d9093347e37c16783e67e423fa56f341"

  bottle :unneeded

  def install
    prefix.install Dir["*"]
    # Use absolute rather than relative path to plugins.
    inreplace prefix/"m" do |s|
      s.gsub! /^\[ -L.*|^\s+\|\| pushd.*|^popd.*/, ""
      s.gsub! /MPATH=.*/, "MPATH=#{prefix}"
    end

    bin.install_symlink "#{prefix}/m" => "m"
    bash_completion.install prefix/"completion/bash/m"
    zsh_completion.install prefix/"completion/zsh/_m"
  end

  test do
    output = pipe_output("#{bin}/m help 2>&1")
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*Swiss Army Knife for Mac OS X.*/, output
  end
end
