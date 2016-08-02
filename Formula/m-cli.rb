class MCli < Formula
  desc "Swiss Army Knife for Mac OS X"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/v0.1.0.tar.gz"
  sha256 "d28f9b4abdb783554eee01432ffb55dbd206f018b6825018f00fe722af799963"

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
