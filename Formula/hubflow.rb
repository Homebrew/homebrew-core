# Note: pull from git tag to get submodules
class Hubflow < Formula
  desc "GitFlow for GitHub"
  homepage "https://datasift.github.io/gitflow/"
  url "https://github.com/datasift/gitflow.git",
      :tag => "1.5.3",
      :revision => "ed032438d2100b826d2fd5c8281b5e07d88ab9eb"
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
