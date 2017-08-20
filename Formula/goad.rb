require "language/go"

class Goad < Formula
  desc "AWS Lambda powered, highly distributed, load testing tool built in Go"
  homepage "https://goad.io/"
  url "https://github.com/goadapp/goad.git",
      :tag => "2.0.3",
      :revision => "1d56f40289699a8fcb81709db7db109b8946e17c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e303913ddbcc7d2284f380ffb6351c7eab64f2fdc8f95864343b97486d88f8b" => :sierra
    sha256 "1ac09ed9e1ec55c4309b4e09171abc4907702ab44e713a068ef8549f2dcb0ed3" => :el_capitan
    sha256 "1740f751efcb6a906a0807ec5d0c308bf9c9b77f1942c9d25bfeec75552c0e80" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/goadapp/goad"
    dir.install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    cd dir do
      system "make", "build"
      bin.install "build/goad"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goad", "--version"
  end
end
