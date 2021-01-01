class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.27.0.tar.gz"
  sha256 "9dc5ce43c63d9d9ff510c6bcd6ae06f3f2f907347e7cbb2bb6513bfb0f151621"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "32d8506f7eedfa4723b9b0acd06759e44e39ea29ec78eb94eba7022a613b192c" => :big_sur
    sha256 "5fba0c6d999b15cad35491431c49ed1b705713179b545bc524c8640be0d2eb8a" => :arm64_big_sur
    sha256 "931988a1192cd06480b0a3818a9732aad47b1d0a33d591fd5f0cc1edaebcff5d" => :catalina
    sha256 "4e1b4ac2a984bb63a895269c694ac2ac5259f4dc974525cad200d2b27c246f70" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
