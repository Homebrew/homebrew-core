class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.25.1.tar.gz"
  sha256 "b6263258490b3c9872db1faaa30e2f5a7981a7f8110e06dea35a8706ed7bf09d"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8b6768c9df0f097a87708b77f6cd1f68808c81567609e7f6a4f6c86fcd3bcc9" => :big_sur
    sha256 "66b13f4889a97b487f9dd2a6b5a02724dc229cbc33ece4c6458e6fa2a2194e34" => :catalina
    sha256 "183d350c5096cbb818b08fd71b30ffe5e27ed4b27a6cb1211edb90226645c968" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
