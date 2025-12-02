class Hr < Formula
  desc "<hr />, for your terminal window"
  homepage "https://github.com/LuRsT/hr"
  url "https://github.com/LuRsT/hr/archive/refs/tags/1.5.tar.gz"
  sha256 "d4bb6e8495a8adaf7a70935172695d06943b4b10efcbfe4f8fcf6d5fe97ca251"
  license "MIT"
  head "https://github.com/LuRsT/hr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef156edf072a61b38e5fd50fa8eb8e71f651ed459132490b8994737eb2691ed7"
  end

  def install
    bin.install "hr"
    man1.install "hr.1"
  end

  test do
    system bin/"hr", "-#-"
  end
end
