# NOTE: Pull from git tag to get submodules
class Hubflow < Formula
  desc "GitFlow for GitHub"
  homepage "https://github.com/datasift/gitflow"
  url "https://github.com/datasift/gitflow.git",
      tag:      "v1.5.4",
      revision: "61a7dbec2bb463216b4cad2645d6721ab713f597"
  license "BSD-2-Clause"
  head "https://github.com/datasift/gitflow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8fabc7a855f66324b448e41cfcb145e6978305b158d8b5034c153764ee79dc53"
  end

  deprecate! date: "2024-03-05", because: :repo_archived

  def install
    ENV["INSTALL_INTO"] = libexec
    system "./install.sh", "install"
    bin.write_exec_script libexec/"git-hf"
  end

  test do
    system bin/"git-hf", "version"
  end
end
