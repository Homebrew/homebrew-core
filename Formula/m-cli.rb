class MCli < Formula
  desc "Swiss Army Knife for Mac OS X"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/v0.0.8.tar.gz"
  sha256 "66956e3f21362f4baca25241dcf912c4e7aa27e329b5adb431338b52fd262a6f"

  def install
    prefix.install Dir["*"]
    inreplace "#{prefix}/m", /^\[ -L.*|^\s+\|\| pushd.*|^popd.*/, ""
    inreplace "#{prefix}/m", /MPATH=.*/, "MPATH=#{prefix}"

    bin.mkpath
    bin.install_symlink "#{prefix}/m" => "m"
    bash_completion.install prefix + "completion/bash/m" => "m"
    zsh_completion.install prefix + "completion/zsh/_m" => "_m"
  end

  test do
    output = pipe_output("m help 2>&1")
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*Swiss Army Knife for Mac OS X.*/, output
  end
end
