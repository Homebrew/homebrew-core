class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.1.3.tar.gz"
  sha256 "90b7ae4ac9d013ab99d0766450e431b4709a40d37a3ff25a53b85747c2f82276"
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
