class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.4.1.tar.gz"
  sha256 "d7dfb237c2de5acdccf717fbf4b141cd6c7ae9f643e12a5d2bc5c3efb0cfc3ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9948361d0bb8240522779c247932b52f24e1898a371bf3c6624b2bd200361a0" => :catalina
    sha256 "cd7f21b971d6ac421e656cc307374d99741aa6aec61ccb037f466ab34c7041f5" => :mojave
    sha256 "fe3113b969e408d527588ac3a7461c02300dcc0c706f019576ac9712a7d51ba2" => :high_sierra
    sha256 "5507e557ffc1f68f66acb003b7b67365b13e59262cef39bba4ac54d304ce5dea" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/miguelmota/cointop"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "test"
  end
end
