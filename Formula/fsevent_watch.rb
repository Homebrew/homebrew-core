class FseventWatch < Formula
  desc "macOS FSEvents client"
  homepage "https://github.com/proger/fsevent_watch"
  url "https://github.com/proger/fsevent_watch/archive/v0.1.tar.gz"
  sha256 "260979f856a61230e03ca1f498c590dd739fd51aba9fa36b55e9cae776dcffe3"
  head "https://github.com/proger/fsevent_watch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0247a4a6826c062993a593ea26db5f4c87370beb3edbd5c358511aa8f37e8a6" => :catalina
    sha256 "726165ea3d49c1244c1058ce37ac1ac900dacfb34ca11e44fa752a3525ed66dc" => :mojave
    sha256 "ef2fd8cd9dc6804e6b48d99f3ef517b397c01ea205b80ec9415147cc211c4e9e" => :high_sierra
    sha256 "63d964a1a42e46191b76fb86a955a56e989c7df86fb4787f6341fc1b8c99a91a" => :sierra
    sha256 "d9ff549a7f9f5b31ffe923beddc1a8ab123c11e76bb833fb882785342d119768" => :el_capitan
    sha256 "085b1a0cdc155ec6833d782ebd86e8109f6a4529ff3719f3605fce5779925456" => :yosemite
    sha256 "900dff7d67ce9b31c9e1a3884315d8ed407cbd89358aed68fda283f7782ff2c6" => :mavericks
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}", "CFLAGS=-DCLI_VERSION=\\\"#{version}\\\""
  end

  test do
    system "#{bin}/fsevent_watch", "--version"
  end
end
