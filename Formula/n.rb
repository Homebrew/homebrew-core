class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.1.2.tar.gz"
  sha256 "75e228fd2978a7ee3372958bb66c9632a3c73bf3544c8933ef418156bfa4510f"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7895a7ea30243d369172cec27e60d43a486cdd7bbef57bd68a1ab416a9a7a013" => :catalina
    sha256 "7895a7ea30243d369172cec27e60d43a486cdd7bbef57bd68a1ab416a9a7a013" => :mojave
    sha256 "7895a7ea30243d369172cec27e60d43a486cdd7bbef57bd68a1ab416a9a7a013" => :high_sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
