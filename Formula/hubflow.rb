# NOTE: Pull from git tag to get submodules
class Hubflow < Formula
  desc "GitFlow for GitHub"
  homepage "https://datasift.github.io/gitflow/"
  url "https://github.com/datasift/gitflow.git",
      tag:      "v1.5.4",
      revision: "61a7dbec2bb463216b4cad2645d6721ab713f597"
  license "BSD-2-Clause"
  head "https://github.com/datasift/gitflow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5fcc66bfe17f292cb37ee437c016a60c9bc46ff63b8bc5ad5ac13cc649421a94"
  end

  def install
    ENV["INSTALL_INTO"] = libexec
    system "./install.sh", "install"
    bin.write_exec_script libexec/"git-hf"
  end

  test do
    system bin/"git-hf", "version"
  end
end
