class FseventWatch < Formula
  desc "macOS FSEvents client"
  homepage "https://github.com/proger/fsevent_watch"
  url "https://github.com/proger/fsevent_watch/archive/v0.2.tar.gz"
  sha256 "1cfd66d551bb5a7ef80b53bcc7952b766cf81ce2059aacdf7380a9870aa0af6c"
  license "MIT"
  head "https://github.com/proger/fsevent_watch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d22101fa98bbaa37a0b7926e3ea7b0c46b55888543b06d3ad3fe3126623058bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a87436ee7bfcf74cf7c0383b32c809161fabedba58405c21d20ba591540a890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "677477269a68d09467089624e2a0c7047daddbbac0db208c01bed88d08595bc4"
    sha256 cellar: :any_skip_relocation, ventura:        "c6acaf3d89a88a1e1c776428193f711e4f80d1bdd244ce8eb223e5c41fab10af"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b7b010f7c899dce0ee2554d4d0f9a660761c01ea9dfece15d1c11bef353957"
    sha256 cellar: :any_skip_relocation, big_sur:        "3450ed18ee786ff504e23bcd1d188511782661d49d9025be30227fefc43a30b8"
    sha256 cellar: :any_skip_relocation, catalina:       "7947abb87aa8cc18551b2931374c7fc9a91503a8b637762360f67ad7fdcdc5ec"
    sha256 cellar: :any_skip_relocation, mojave:         "4f9c9f11ee85b971d840b9b3626ed55c7b9160308900de2278a7b159a384f0f0"
  end

  depends_on :macos

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}", "CFLAGS=-DCLI_VERSION=\\\"#{version}\\\""
  end

  test do
    system "#{bin}/fsevent_watch", "--version"
  end
end
