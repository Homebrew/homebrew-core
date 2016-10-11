# Note: pull from git tag to get submodules
class Hubflow < Formula
  desc "GitFlow for GitHub"
  homepage "https://datasift.github.io/gitflow/"
  url "https://github.com/datasift/gitflow.git",
    :tag => "1.5.2",
    :revision => "8bb7890b39f782864d55cfca5a156c926fa53c0d"
  head "https://github.com/datasift/gitflow.git"

  bottle :unneeded

  def install
    ENV["INSTALL_INTO"] = libexec
    system "./install.sh", "install"
    bin.write_exec_script libexec/"git-hf"
  end

  test do
    system bin/"git-hf", "version"
  end
end
