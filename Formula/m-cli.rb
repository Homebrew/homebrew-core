class MCli < Formula
  desc "Swiss Army Knife for Mac OS X"
  homepage "https://github.com/rgcr/m-cli"
  url "https://github.com/rgcr/m-cli/archive/v0.0.9.tar.gz"
  sha256 "957e86c03a8196f60c852672aa0a7c86d9093347e37c16783e67e423fa56f341"

  bottle do
    cellar :any_skip_relocation
    sha256 "980e5335b55609427d6100ed2a7d7cfe815fafc4922e2a302f3104524ff23fe1" => :el_capitan
    sha256 "e24d33e100fba2466180bee916c395a74773722b2abe59fef13cde4cfdc1f8ef" => :yosemite
    sha256 "2cc6472a01a3bf7a73ef4608c7005b1937e23cc51b0762fc49f5c237316acffb" => :mavericks
  end

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
